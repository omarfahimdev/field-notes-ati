import 'package:uuid/uuid.dart';

import '../../../core/storage/local_storage.dart';
import '../../../core/storage/sync_op.dart';
import '../../../core/sync/sync_service.dart';
import '../domain/customer.dart';

class CustomerRepository {
  CustomerRepository(this._storage, this._sync);
  final LocalStorage _storage;
  final SyncService _sync;
  final _uuid = const Uuid();
  static const _key = 'customers';

  List<Customer> getAll() {
    final list = _storage.readList(_key).where((e) => e['isDeleted'] != true).toList();
    return list.map(_fromMap).toList();
  }

  Customer _fromMap(Map<String, dynamic> m) => Customer(
    id: (m['remoteId'] ?? m['id'] ?? 0) is num ? ((m['remoteId'] ?? m['id'] ?? 0) as num).toInt() : 0,
    fullName: (m['fullName'] ?? '').toString(),
    phone: (m['phone'] ?? '').toString(),
    email: (m['email'] ?? '').toString(),
    address: m['address']?.toString(),
  );

  String? localIdForRemote(int remoteId) {
    for (final e in _storage.readList(_key)) {
      final rid = (e['remoteId'] ?? e['id']) as num?;
      if (rid?.toInt() == remoteId) return e['localId']?.toString();
    }
    return null;
  }

  Map<String, dynamic>? rawByLocalId(String localId) => _storage.readList(_key).where((e)=>e['localId']==localId).cast<Map<String,dynamic>?>().firstOrNull;

  Future<Customer> create({required String fullName, required String phone, required String email, String? address}) async {
    final localId = _uuid.v4();
    final map = {'localId': localId, 'remoteId': null, 'fullName': fullName, 'phone': phone, 'email': email, 'address': address, 'dirty': true, 'isDeleted': false};
    final list = _storage.readList(_key)..add(map);
    await _storage.writeList(_key, list);
    await _sync.enqueue(SyncOp(id: _uuid.v4(), entity: 'customer', action: 'create', localId: localId, payload: map, createdAt: DateTime.now().millisecondsSinceEpoch));
    return _fromMap(map);
  }

  Future<void> update(String localId, {required String fullName, required String phone, required String email, String? address}) async {
    final list = _storage.readList(_key);
    final i = list.indexWhere((e) => e['localId'] == localId);
    if (i < 0) return;
    final prev = list[i];
    final map = {...prev, 'fullName': fullName, 'phone': phone, 'email': email, 'address': address, 'dirty': true};
    list[i] = map;
    await _storage.writeList(_key, list);
    await _sync.enqueue(SyncOp(id: _uuid.v4(), entity: 'customer', action: 'update', localId: localId, remoteId: (prev['remoteId'] as num?)?.toInt(), payload: map, createdAt: DateTime.now().millisecondsSinceEpoch));
  }

  Future<void> delete(String localId) async {
    final list = _storage.readList(_key);
    final i = list.indexWhere((e) => e['localId'] == localId);
    if (i < 0) return;
    final prev = list[i];
    final rid = (prev['remoteId'] as num?)?.toInt();
    // remove local
    list.removeAt(i);
    await _storage.writeList(_key, list);
    // cascade local sites/notes
    await _cascadeDeleteCustomer(localId, rid);
    await _sync.enqueue(SyncOp(id: _uuid.v4(), entity: 'customer', action: 'delete', localId: localId, remoteId: rid, createdAt: DateTime.now().millisecondsSinceEpoch));
  }

  Future<void> _cascadeDeleteCustomer(String customerLocalId, int? customerRemoteId) async {
    final sites = _storage.readList('sites');
    final notes = _storage.readList('notes');
    final removedSiteLocalIds = <String>{};
    final keptSites = <Map<String, dynamic>>[];
    for (final s in sites) {
      final c = s['customer'];
      final cid = c is Map ? c['localId']?.toString() : null;
      final crid = c is Map ? (c['remoteId'] ?? c['id']) as num? : null;
      if (cid == customerLocalId || (customerRemoteId != null && crid?.toInt() == customerRemoteId)) {
        removedSiteLocalIds.add(s['localId'].toString());
      } else {
        keptSites.add(s);
      }
    }
    await _storage.writeList('sites', keptSites);
    final keptNotes = notes.where((n) {
      final s = n['site'];
      final sid = s is Map ? s['localId']?.toString() : null;
      return !removedSiteLocalIds.contains(sid);
    }).toList();
    await _storage.writeList('notes', keptNotes);
  }
}
