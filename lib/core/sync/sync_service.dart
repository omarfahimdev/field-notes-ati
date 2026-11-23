import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../errors/app_exception.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';
import '../storage/sync_op.dart';

class SyncService {
  SyncService(this._storage, this._api);
  final LocalStorage _storage;
  final ApiClient _api;
  final _uuid = const Uuid();
  final _changes = StreamController<void>.broadcast();
  Stream<void> get changes => _changes.stream;
  bool _syncing = false;

  Future<void> enqueue(SyncOp op) async {
    final q = _storage.readSyncQueue();
    // collapse: if same localId+entity pending create/update, replace payload
    final idx = q.indexWhere((e) => e['localId'] == op.localId && e['entity'] == op.entity);
    if (idx >= 0) {
      final existing = SyncOp.fromJson(q[idx]);
      if (op.action == 'delete') {
        if (existing.action == 'create') { q.removeAt(idx); } else { q[idx] = op.toJson(); }
      } else if (existing.action == 'create') {
        q[idx] = SyncOp(id: existing.id, entity: existing.entity, action: 'create', localId: existing.localId, remoteId: existing.remoteId, payload: op.payload, createdAt: existing.createdAt).toJson();
      } else {
        q[idx] = op.toJson();
      }
    } else {
      q.add(op.toJson());
    }
    await _storage.writeSyncQueue(q);
    _changes.add(null);
    unawaited(sync());
  }

  int get pendingCount => _storage.readSyncQueue().length;

  Future<bool> get isOnline async {
    final r = await Connectivity().checkConnectivity();
    return r.any((c) => c != ConnectivityResult.none);
  }

  Future<void> sync() async {
    if (_syncing) return;
    if (!await isOnline) return;
    if (_storage.token == null) return;
    _syncing = true;
    try {
      await _push();
      await pullAll();
    } catch (e) {
      debugPrint('Sync error: $e');
    } finally {
      _syncing = false;
      _changes.add(null);
    }
  }

  Future<void> _push() async {
    var q = _storage.readSyncQueue();
    final ordered = q.map(SyncOp.fromJson).toList()..sort((a,b)=>a.createdAt.compareTo(b.createdAt));
    for (final op in ordered) {
      try {
        await _applyOp(op);
        q = _storage.readSyncQueue();
        q.removeWhere((e) => e['id'] == op.id);
        await _storage.writeSyncQueue(q);
      } on AppException catch (e) {
        if (e.statusCode == 404 || e.statusCode == 409) {
          q = _storage.readSyncQueue();
          q.removeWhere((e) => e['id'] == op.id);
          await _storage.writeSyncQueue(q);
        } else {
          break; // network/server issue, retry later
        }
      }
    }
  }

  Future<void> _applyOp(SyncOp op) async {
    if (op.entity == 'customer') return _applyCustomer(op);
    if (op.entity == 'site') return _applySite(op);
    if (op.entity == 'note') return _applyNote(op);
  }

  Map<String, dynamic>? _findLocal(String key, String localId) {
    final list = _storage.readList(key);
    for (final e in list) { if (e['localId'] == localId) return e; }
    return null;
  }

  Future<void> _replaceLocal(String key, String localId, Map<String, dynamic> item) async {
    final list = _storage.readList(key);
    final i = list.indexWhere((e) => e['localId'] == localId);
    if (i >= 0) list[i] = item; else list.add(item);
    await _storage.writeList(key, list);
  }

  Future<void> _applyCustomer(SyncOp op) async {
    final local = _findLocal('customers', op.localId);
    if (op.action == 'delete') {
      final rid = op.remoteId ?? (local?['remoteId'] as num?)?.toInt();
      if (rid != null) await _api.delete('/api/customers/$rid');
      return;
    }
    final payload = op.payload ?? local ?? {};
    final body = {'fullName': payload['fullName'], 'phone': payload['phone'], 'email': payload['email'], 'address': payload['address']};
    if (op.action == 'create') {
      final res = Map<String, dynamic>.from(await _api.post('/api/customers', data: body) as Map);
      final merged = {...?local, ...res, 'localId': op.localId, 'remoteId': res['id'], 'dirty': false, 'isDeleted': false};
      await _replaceLocal('customers', op.localId, merged);
      await _remapCustomerRefs(op.localId, (res['id'] as num).toInt());
    } else {
      final rid = op.remoteId ?? (local?['remoteId'] as num?)?.toInt();
      if (rid == null) return;
      final res = Map<String, dynamic>.from(await _api.put('/api/customers/$rid', data: body) as Map);
      final merged = {...?local, ...res, 'localId': op.localId, 'remoteId': res['id'], 'dirty': false, 'isDeleted': false};
      await _replaceLocal('customers', op.localId, merged);
    }
  }

  Future<void> _remapCustomerRefs(String localId, int remoteId) async {
    // update pending ops and local sites referencing customer localId
    final sq = _storage.readSyncQueue();
    var changed = false;
    for (var i=0;i<sq.length;i++) {
      final op = SyncOp.fromJson(sq[i]);
      if (op.entity == 'site' && op.payload != null) {
        final c = op.payload!['customer'];
        if (c is Map && c['localId'] == localId) {
          final p = Map<String, dynamic>.from(op.payload!);
          p['customer'] = {'id': remoteId};
          sq[i] = SyncOp(id: op.id, entity: op.entity, action: op.action, localId: op.localId, remoteId: op.remoteId, payload: p, createdAt: op.createdAt).toJson();
          changed = true;
        }
      }
    }
    if (changed) await _storage.writeSyncQueue(sq);
    final sites = _storage.readList('sites');
    var sc = false;
    for (var i=0;i<sites.length;i++) {
      final c = sites[i]['customer'];
      if (c is Map && c['localId'] == localId) {
        final s = Map<String, dynamic>.from(sites[i]);
        s['customer'] = {...Map<String, dynamic>.from(c), 'id': remoteId, 'remoteId': remoteId};
        sites[i]=s; sc=true;
      }
    }
    if (sc) await _storage.writeList('sites', sites);
  }

  int? _resolveCustomerRemoteId(Map<String, dynamic>? local) {
    if (local == null) return null;
    final c = local['customer'];
    if (c is Map) {
      final rid = (c['remoteId'] ?? c['id']) as num?;
      if (rid != null && rid.toInt() > 0) return rid.toInt();
      final lid = c['localId']?.toString();
      if (lid != null) {
        final found = _findLocal('customers', lid);
        return (found?['remoteId'] as num?)?.toInt();
      }
    }
    return null;
  }

  Future<void> _applySite(SyncOp op) async {
    final local = _findLocal('sites', op.localId);
    if (op.action == 'delete') {
      final rid = op.remoteId ?? (local?['remoteId'] as num?)?.toInt();
      if (rid != null) await _api.delete('/api/sites/$rid');
      return;
    }
    final payload = op.payload ?? local ?? {};
    final custRid = _resolveCustomerRemoteId(payload) ?? _resolveCustomerRemoteId(local);
    if (custRid == null) throw const AppException('Customer not synced yet');
    final body = {'name': payload['name'], 'address': payload['address'], 'customer': {'id': custRid}};
    if (op.action == 'create') {
      final res = Map<String, dynamic>.from(await _api.post('/api/sites', data: body) as Map);
      final merged = {...?local, ...res, 'localId': op.localId, 'remoteId': res['id'], 'dirty': false, 'isDeleted': false};
      await _replaceLocal('sites', op.localId, merged);
      await _remapSiteRefs(op.localId, (res['id'] as num).toInt());
    } else {
      final rid = op.remoteId ?? (local?['remoteId'] as num?)?.toInt();
      if (rid == null) return;
      final res = Map<String, dynamic>.from(await _api.put('/api/sites/$rid', data: body) as Map);
      final merged = {...?local, ...res, 'localId': op.localId, 'remoteId': res['id'], 'dirty': false, 'isDeleted': false};
      await _replaceLocal('sites', op.localId, merged);
    }
  }

  Future<void> _remapSiteRefs(String localId, int remoteId) async {
    final sq = _storage.readSyncQueue();
    var changed = false;
    for (var i=0;i<sq.length;i++) {
      final op = SyncOp.fromJson(sq[i]);
      if (op.entity == 'note' && op.payload != null) {
        final s = op.payload!['site'];
        if (s is Map && s['localId'] == localId) {
          final p = Map<String, dynamic>.from(op.payload!);
          p['site'] = {'id': remoteId};
          sq[i] = SyncOp(id: op.id, entity: op.entity, action: op.action, localId: op.localId, remoteId: op.remoteId, payload: p, createdAt: op.createdAt).toJson();
          changed = true;
        }
      }
    }
    if (changed) await _storage.writeSyncQueue(sq);
  }

  int? _resolveSiteRemoteId(Map<String, dynamic>? local) {
    if (local == null) return null;
    final s = local['site'];
    if (s is Map) {
      final rid = (s['remoteId'] ?? s['id']) as num?;
      if (rid != null && rid.toInt() > 0) return rid.toInt();
      final lid = s['localId']?.toString();
      if (lid != null) {
        final found = _findLocal('sites', lid);
        return (found?['remoteId'] as num?)?.toInt();
      }
    }
    return null;
  }

  Future<void> _applyNote(SyncOp op) async {
    final local = _findLocal('notes', op.localId);
    if (op.action == 'delete') {
      final rid = op.remoteId ?? (local?['remoteId'] as num?)?.toInt();
      if (rid != null) await _api.delete('/api/field-notes/$rid');
      return;
    }
    final payload = op.payload ?? local ?? {};
    final siteRid = _resolveSiteRemoteId(payload) ?? _resolveSiteRemoteId(local);
    if (siteRid == null) throw const AppException('Site not synced yet');
    final body = {
      'site': {'id': siteRid},
      'title': payload['title'],
      'description': payload['description'],
      'location': payload['location'],
      'occurredAt': payload['occurredAt'],
      'status': payload['status'] ?? 'draft',
      'photoUrl': payload['photoUrl'],
    };
    if (op.action == 'create') {
      final res = Map<String, dynamic>.from(await _api.post('/api/field-notes', data: body) as Map);
      final merged = {...?local, ...res, 'localId': op.localId, 'remoteId': res['id'], 'dirty': false, 'isDeleted': false};
      await _replaceLocal('notes', op.localId, merged);
    } else {
      final rid = op.remoteId ?? (local?['remoteId'] as num?)?.toInt();
      if (rid == null) return;
      final res = Map<String, dynamic>.from(await _api.put('/api/field-notes/$rid', data: body) as Map);
      final merged = {...?local, ...res, 'localId': op.localId, 'remoteId': res['id'], 'dirty': false, 'isDeleted': false};
      await _replaceLocal('notes', op.localId, merged);
    }
  }

  Future<void> pullAll() async {
    if (!await isOnline || _storage.token == null) return;
    await _pullEntity('customers', '/api/customers');
    await _pullEntity('sites', '/api/sites');
    await _pullEntity('notes', '/api/field-notes');
    _changes.add(null);
  }

  Future<void> _pullEntity(String key, String path) async {
    final res = await _api.get(path);
    if (res is! List) return;
    final remote = res.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    final local = _storage.readList(key);
    final byRemote = <int, Map<String, dynamic>>{};
    final dirtyLocal = <Map<String, dynamic>>[];
    for (final e in local) {
      final rid = (e['remoteId'] ?? e['id']) as num?;
      final isDirty = e['dirty'] == true;
      final hasRemote = rid != null;
      if (isDirty) {
        dirtyLocal.add(e);
        continue;
      }
      if (!hasRemote) {
        dirtyLocal.add(e);
        continue;
      }
      byRemote[rid.toInt()] = e;
    }
    final merged = <Map<String, dynamic>>[];
    for (final r in remote) {
      final rid = (r['id'] as num?)?.toInt();
      if (rid == null) continue;
      final existing = byRemote[rid];
      final localId = existing?['localId']?.toString() ?? _uuid.v4();
      merged.add({...r, 'localId': localId, 'remoteId': rid, 'dirty': false, 'isDeleted': false});
    }
    // keep dirty/local-only items
    for (final d in dirtyLocal) {
      final rid = (d['remoteId'] ?? d['id']) as num?;
      if (rid != null && merged.any((m) => (m['remoteId'] as num?)?.toInt() == rid.toInt())) continue;
      merged.add(d);
    }
    await _storage.writeList(key, merged);
  }
}
