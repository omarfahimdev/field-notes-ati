import '../../../core/storage/local_storage.dart';
import '../../notes/domain/note_status.dart';

class SettingsRepository {
  SettingsRepository(this._storage);
  final LocalStorage _storage;

  NoteStatus getDefaultStatus() {
    final raw = _storage.defaultNoteStatus;
    return NoteStatus.fromJson(raw, fallback: NoteStatus.draft);
  }

  Future<void> setDefaultStatus(NoteStatus status) async {
    final value = status == NoteStatus.inProgress ? 'inProgress' : status.name;
    await _storage.setDefaultNoteStatus(value);
  }
}
