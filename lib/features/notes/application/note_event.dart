part of 'note_bloc.dart';
sealed class NoteEvent extends Equatable { const NoteEvent(); @override List<Object?> get props => []; }
class NotesLoaded extends NoteEvent { const NotesLoaded(); }
class NoteAdded extends NoteEvent { final FieldNote note; const NoteAdded(this.note); }
class NoteUpdated extends NoteEvent { final String localId; final FieldNote note; const NoteUpdated(this.localId, this.note); }
class NoteDeleted extends NoteEvent { final String localId; const NoteDeleted(this.localId); }
