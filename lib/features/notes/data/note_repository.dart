import 'package:uuid/uuid.dart';

import '../../../core/storage/local_storage.dart';
import '../../../core/storage/sync_op.dart';
import '../../../core/sync/sync_service.dart';
import '../../customers/domain/customer.dart';
import '../../sites/domain/site.dart';
import '../domain/field_note.dart';
import '../domain/location.dart';
import '../domain/note_status.dart';

class NoteRepository {
  NoteRepository(this._storage, this._sync);
  final LocalStorage _storage;
  final SyncService _sync;
  final _uuid = const Uuid();
  static const _key = 'notes';

  List<FieldNote> getAll() {
    final list = _storage.readList(_key).where((e) => e['isDeleted'] != true).toList();
    return list.map(_fromMap).whereType<FieldNote>().toList()
      ..sort((a,b)=> (b.occurredAt ?? DateTime(0)).compareTo(a.occurredAt ?? DateTime(0)));
  }

  FieldNote? _fromMap(Map<String, dynamic> m) {
    final s = m['site'];
    if (s is! Map) return null;
    final sm = Map<String, dynamic>.from(s);
    final c = sm['customer'];
    if (c is! Map) return null;
    final cm = Map<String, dynamic>.from(c);
    final customer = Customer(
      id: ((cm['remoteId'] ?? cm['id'] ?? 0) as num?)?.toInt() ?? 0,
      fullName: (cm['fullName'] ?? '').toString(),
      phone: (cm['phone'] ?? '').toString(),
      email: (cm['email'] ?? '').toString(),
      address: cm['address']?.toString(),
    );
    final site = Site(
      id: ((sm['remoteId'] ?? sm['id'] ?? 0) as num?)?.toInt() ?? 0,
      name: (sm['name'] ?? '').toString(),
      address: (sm['address'] ?? '').toString(),
      customer: customer,
    );
    Location? loc;
    final l = m['location'];
    if (l is Map) {
      final lm = Map<String, dynamic>.from(l);
      loc = Location(latitude: (lm['latitude'] as num?)?.toDouble(), longitude: (lm['longitude'] as num?)?.toDouble(), label: lm['label']?.toString() ?? lm['locationLabel']?.toString());
      if (!loc.hasLocation && (loc.label == null || loc.label!.isEmpty)) loc = null;
    }
    DateTime? occurredAt;
    final oa = m['occurredAt'];
    if (oa is String && oa.isNotEmpty) { occurredAt = DateTime.tryParse(oa); }
    return FieldNote(
      id: ((m['remoteId'] ?? m['id'] ?? 0) as num?)?.toInt() ?? 0,
      site: site,
      title: (m['title'] ?? '').toString(),
      description: (m['description'] ?? '').toString(),
      location: loc,
      occurredAt: occurredAt,
      status: NoteStatus.fromJson(m['status']),
      photoUrl: m['photoUrl']?.toString(),
    );
  }

  String? localIdForRemote(int remoteId) {
    for (final e in _storage.readList(_key)) {
      final rid = (e['remoteId'] ?? e['id']) as num?;
      if (rid?.toInt() == remoteId) return e['localId']?.toString();
    }
    return null;
  }

  Future<FieldNote> create(FieldNote note) async {
    final localId = _uuid.v4();
    final map = _toMap(note, localId: localId, remoteId: null, dirty: true);
    final list = _storage.readList(_key)..add(map);
    await _storage.writeList(_key, list);
    await _sync.enqueue(SyncOp(id: _uuid.v4(), entity: 'note', action: 'create', localId: localId, payload: map, createdAt: DateTime.now().millisecondsSinceEpoch));
    return _fromMap(map)!;
  }

  Future<void> update(String localId, FieldNote note) async {
    final list = _storage.readList(_key);
    final i = list.indexWhere((e) => e['localId'] == localId);
    if (i < 0) return;
    final prev = list[i];
    final rid = (prev['remoteId'] as num?)?.toInt();
    final map = _toMap(note, localId: localId, remoteId: rid, dirty: true);
    list[i] = {...prev, ...map};
    await _storage.writeList(_key, list);
    await _sync.enqueue(SyncOp(id: _uuid.v4(), entity: 'note', action: 'update', localId: localId, remoteId: rid, payload: map, createdAt: DateTime.now().millisecondsSinceEpoch));
  }

  Future<void> delete(String localId) async {
    final list = _storage.readList(_key);
    final i = list.indexWhere((e) => e['localId'] == localId);
    if (i < 0) return;
    final prev = list[i];
    final rid = (prev['remoteId'] as num?)?.toInt();
    list.removeAt(i);
    await _storage.writeList(_key, list);
    await _sync.enqueue(SyncOp(id: _uuid.v4(), entity: 'note', action: 'delete', localId: localId, remoteId: rid, createdAt: DateTime.now().millisecondsSinceEpoch));
  }

  Map<String, dynamic> _toMap(FieldNote note, {required String localId, required int? remoteId, required bool dirty}) {
    final siteLocalId = _storage.readList('sites').where((s){
      final rid = (s['remoteId'] ?? s['id']) as num?;
      return rid?.toInt() == note.site.id;
    }).map((s)=>s['localId']?.toString()).firstOrNull;
    final custLocalId = _storage.readList('customers').where((c){
      final rid = (c['remoteId'] ?? c['id']) as num?;
      return rid?.toInt() == note.site.customer.id;
    }).map((c)=>c['localId']?.toString()).firstOrNull;
    return {
      'localId': localId,
      'remoteId': remoteId,
      'id': remoteId,
      'title': note.title,
      'description': note.description,
      'status': note.status.apiName,
      'occurredAt': note.occurredAt?.toIso8601String(),
      'photoUrl': note.photoUrl,
      'location': note.location == null ? null : {
        'latitude': note.location!.latitude,
        'longitude': note.location!.longitude,
        'label': note.location!.label,
      },
      'site': {
        'id': note.site.id,
        'localId': siteLocalId,
        'remoteId': note.site.id > 0 ? note.site.id : null,
        'name': note.site.name,
        'address': note.site.address,
        'customer': {
          'id': note.site.customer.id,
          'localId': custLocalId,
          'remoteId': note.site.customer.id > 0 ? note.site.customer.id : null,
          'fullName': note.site.customer.fullName,
          'phone': note.site.customer.phone,
          'email': note.site.customer.email,
          'address': note.site.customer.address,
        },
      },
      'dirty': dirty,
      'isDeleted': false,
    };
  }
}
