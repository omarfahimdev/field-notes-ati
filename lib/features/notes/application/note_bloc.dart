import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/sync/sync_service.dart';
import '../data/note_repository.dart';
import '../domain/field_note.dart';
part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc(this._repo, this._sync) : super(const NoteState()) {
    on<NotesLoaded>(_onLoaded);
    on<NoteAdded>(_onAdded);
    on<NoteUpdated>(_onUpdated);
    on<NoteDeleted>(_onDeleted);
    _sub = _sync.changes.listen((_) => add(const NotesLoaded()));
  }
  final NoteRepository _repo; final SyncService _sync; StreamSubscription? _sub;
  void _onLoaded(NotesLoaded e, Emitter<NoteState> emit) => emit(state.copyWith(items: _repo.getAll(), loading: false));
  Future<void> _onAdded(NoteAdded e, Emitter<NoteState> emit) async { await _repo.create(e.note); add(const NotesLoaded()); }
  Future<void> _onUpdated(NoteUpdated e, Emitter<NoteState> emit) async { await _repo.update(e.localId, e.note); add(const NotesLoaded()); }
  Future<void> _onDeleted(NoteDeleted e, Emitter<NoteState> emit) async { await _repo.delete(e.localId); add(const NotesLoaded()); }
  @override Future<void> close(){_sub?.cancel(); return super.close();}
}
