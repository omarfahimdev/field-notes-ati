import 'package:field_notes/features/notes/domain/location.dart';
import 'package:field_notes/features/sites/domain/site.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'note_status.dart';

part 'field_note.freezed.dart';
part 'field_note.g.dart';

@freezed
abstract class FieldNote with _$FieldNote {
  const FieldNote._();

  factory FieldNote({
    required int id,
    required Site site,
    required String title,
    required String description,
    Location? location,
    DateTime? occurredAt,
    @Default(NoteStatus.draft) NoteStatus status,
    String? photoUrl,
  }) = _FieldNote;

  factory FieldNote.fromJson(Map<String, dynamic> json) => _$FieldNoteFromJson(json);

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  bool get hasLocation => location?.hasLocation ?? false;
}
