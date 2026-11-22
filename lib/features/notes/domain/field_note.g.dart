// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FieldNote _$FieldNoteFromJson(Map<String, dynamic> json) => _FieldNote(
  id: (json['id'] as num).toInt(),
  site: Site.fromJson(json['site'] as Map<String, dynamic>),
  title: json['title'] as String,
  description: json['description'] as String,
  location: json['location'] == null
      ? null
      : Location.fromJson(json['location'] as Map<String, dynamic>),
  occurredAt: json['occurredAt'] == null
      ? null
      : DateTime.parse(json['occurredAt'] as String),
  status: $enumDecodeNullable(_$NoteStatusEnumMap, json['status']),
  photoUrl: json['photoUrl'] as String?,
);

Map<String, dynamic> _$FieldNoteToJson(_FieldNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'site': instance.site,
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'occurredAt': instance.occurredAt?.toIso8601String(),
      'status': _$NoteStatusEnumMap[instance.status],
      'photoUrl': instance.photoUrl,
    };

const _$NoteStatusEnumMap = {
  NoteStatus.draft: 'draft',
  NoteStatus.inProgress: 'inProgress',
  NoteStatus.completed: 'completed',
  NoteStatus.followUp: 'followUp',
};
