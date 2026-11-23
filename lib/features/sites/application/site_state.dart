part of 'site_bloc.dart';
class SiteState extends Equatable { final List<Site> items; final bool loading; const SiteState({this.items=const[], this.loading=true});
  SiteState copyWith({List<Site>? items,bool? loading})=>SiteState(items: items??this.items, loading: loading??this.loading);
  @override List<Object?> get props => [items, loading]; }
