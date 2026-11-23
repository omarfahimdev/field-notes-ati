import 'package:flutter_bloc/flutter_bloc.dart';
import '../../notes/domain/note_status.dart';
import '../data/settings_repository.dart';

class SettingsCubit extends Cubit<NoteStatus> {
  SettingsCubit(this._repo) : super(_repo.getDefaultStatus());
  final SettingsRepository _repo;

  Future<void> setDefault(NoteStatus status) async {
    await _repo.setDefaultStatus(status);
    emit(status);
  }
}
