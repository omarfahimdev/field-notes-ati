import 'dart:convert';

class SyncOp {
  final String id;
  final String entity; // customer, site, note
  final String action; // create, update, delete
  final String localId;
  final int? remoteId;
  final Map<String, dynamic>? payload;
  final int createdAt;

  SyncOp({required this.id, required this.entity, required this.action, required this.localId, this.remoteId, this.payload, required this.createdAt});

  Map<String, dynamic> toJson() => {
    'id': id, 'entity': entity, 'action': action, 'localId': localId, 'remoteId': remoteId, 'payload': payload, 'createdAt': createdAt,
  };

  factory SyncOp.fromJson(Map<String, dynamic> json) => SyncOp(
    id: json['id'].toString(),
    entity: json['entity']?.toString() ?? '',
    action: json['action']?.toString() ?? '',
    localId: json['localId']?.toString() ?? '',
    remoteId: (json['remoteId'] as num?)?.toInt(),
    payload: json['payload'] is Map ? Map<String, dynamic>.from(json['payload']) : null,
    createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
  );

  String encode() => jsonEncode(toJson());
}
