import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/sync/sync_service.dart';
import '../data/site_repository.dart';
import '../domain/site.dart';
part 'site_event.dart';
part 'site_state.dart';

class SiteBloc extends Bloc<SiteEvent, SiteState> {
  SiteBloc(this._repo, this._sync) : super(const SiteState()) {
    on<SitesLoaded>(_onLoaded);
    on<SiteAdded>(_onAdded);
    on<SiteUpdated>(_onUpdated);
    on<SiteDeleted>(_onDeleted);
    _sub = _sync.changes.listen((_) => add(const SitesLoaded()));
  }
  final SiteRepository _repo; final SyncService _sync; StreamSubscription? _sub;
  void _onLoaded(SitesLoaded e, Emitter<SiteState> emit) => emit(state.copyWith(items: _repo.getAll(), loading: false));
  Future<void> _onAdded(SiteAdded e, Emitter<SiteState> emit) async { await _repo.create(name: e.name, address: e.address, customerRaw: e.customerRaw); add(const SitesLoaded()); }
  Future<void> _onUpdated(SiteUpdated e, Emitter<SiteState> emit) async { await _repo.update(e.localId, name: e.name, address: e.address, customerRaw: e.customerRaw); add(const SitesLoaded()); }
  Future<void> _onDeleted(SiteDeleted e, Emitter<SiteState> emit) async { await _repo.delete(e.localId); add(const SitesLoaded()); }
  @override Future<void> close(){_sub?.cancel(); return super.close();}
}
