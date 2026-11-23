part of 'note_bloc.dart';
class NoteState extends Equatable { final List<FieldNote> items; final bool loading; const NoteState({this.items=const[], this.loading=true});
  NoteState copyWith({List<FieldNote>? items,bool? loading})=>NoteState(items: items??this.items, loading: loading??this.loading);
  @override List<Object?> get props => [items, loading]; }
