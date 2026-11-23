import 'package:uuid/uuid.dart';

import '../../../core/storage/local_storage.dart';
import '../../../core/storage/sync_op.dart';
import '../../../core/sync/sync_service.dart';
import '../../customers/domain/customer.dart';
import '../domain/site.dart';

class SiteRepository {
  SiteRepository(this._storage, this._sync);
  final LocalStorage _storage;
  final SyncService _sync;
  final _uuid = const Uuid();
  static const _key = 'sites';

  List<Site> getAll() {
    final list = _storage.readList(_key).where((e) => e['isDeleted'] != true).toList();
    return list.map(_fromMap).whereType<Site>().toList();
  }

  Site? _fromMap(Map<String, dynamic> m) {
    final c = m['customer'];
    if (c is! Map) return null;
    final cm = Map<String, dynamic>.from(c);
    final customer = Customer(
      id: ((cm['remoteId'] ?? cm['id'] ?? 0) as num?)?.toInt() ?? 0,
      fullName: (cm['fullName'] ?? '').toString(),
      phone: (cm['phone'] ?? '').toString(),
      email: (cm['email'] ?? '').toString(),
      address: cm['address']?.toString(),
    );
    return Site(
      id: ((m['remoteId'] ?? m['id'] ?? 0) as num?)?.toInt() ?? 0,
      name: (m['name'] ?? '').toString(),
      address: (m['address'] ?? '').toString(),
      customer: customer,
    );
  }

  String? localIdForRemote(int remoteId) {
    for (final e in _storage.readList(_key)) {
      final rid = (e['remoteId'] ?? e['id']) as num?;
      if (rid?.toInt() == remoteId) return e['localId']?.toString();
    }
    return null;
  }

  Map<String, dynamic>? rawByLocalId(String localId) => _storage.readList(_key).where((e)=>e['localId']==localId).cast<Map<String,dynamic>?>().firstOrNull;

  Future<Site> create({required String name, required String address, required Map<String, dynamic> customerRaw}) async {
    final localId = _uuid.v4();
    final map = {'localId': localId, 'remoteId': null, 'name': name, 'address': address, 'customer': customerRaw, 'dirty': true, 'isDeleted': false};
    final list = _storage.readList(_key)..add(map);
    await _storage.writeList(_key, list);
    await _sync.enqueue(SyncOp(id: _uuid.v4(), entity: 'site', action: 'create', localId: localId, payload: map, createdAt: DateTime.now().millisecondsSinceEpoch));
    return _fromMap(map)!;
  }

  Future<void> update(String localId, {required String name, required String address, required Map<String, dynamic> customerRaw}) async {
    final list = _storage.readList(_key);
    final i = list.indexWhere((e) => e['localId'] == localId);
    if (i < 0) return;
    final prev = list[i];
    final map = {...prev, 'name': name, 'address': address, 'customer': customerRaw, 'dirty': true};
    list[i] = map;
    await _storage.writeList(_key, list);
    await _sync.enqueue(SyncOp(id: _uuid.v4(), entity: 'site', action: 'update', localId: localId, remoteId: (prev['remoteId'] as num?)?.toInt(), payload: map, createdAt: DateTime.now().millisecondsSinceEpoch));
  }

  Future<void> delete(String localId) async {
    final list = _storage.readList(_key);
    final i = list.indexWhere((e) => e['localId'] == localId);
    if (i < 0) return;
    final prev = list[i];
    final rid = (prev['remoteId'] as num?)?.toInt();
    list.removeAt(i);
    await _storage.writeList(_key, list);
    // cascade notes
    final notes = _storage.readList('notes');
    notes.removeWhere((n){ final s=n['site']; return s is Map && s['localId']?.toString()==localId; });
    await _storage.writeList('notes', notes);
    await _sync.enqueue(SyncOp(id: _uuid.v4(), entity: 'site', action: 'delete', localId: localId, remoteId: rid, createdAt: DateTime.now().millisecondsSinceEpoch));
  }
}
