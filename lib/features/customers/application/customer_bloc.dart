import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/sync/sync_service.dart';
import '../data/customer_repository.dart';
import '../domain/customer.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc(this._repo, this._sync) : super(const CustomerState()) {
    on<CustomersLoaded>(_onLoaded);
    on<CustomerAdded>(_onAdded);
    on<CustomerUpdated>(_onUpdated);
    on<CustomerDeleted>(_onDeleted);
    _sub = _sync.changes.listen((_) => add(const CustomersLoaded()));
  }
  final CustomerRepository _repo;
  final SyncService _sync;
  StreamSubscription? _sub;

  void _onLoaded(CustomersLoaded e, Emitter<CustomerState> emit) {
    emit(state.copyWith(items: _repo.getAll(), loading: false));
  }

  Future<void> _onAdded(CustomerAdded e, Emitter<CustomerState> emit) async {
    await _repo.create(fullName: e.fullName, phone: e.phone, email: e.email, address: e.address);
    add(const CustomersLoaded());
  }
  Future<void> _onUpdated(CustomerUpdated e, Emitter<CustomerState> emit) async {
    await _repo.update(e.localId, fullName: e.fullName, phone: e.phone, email: e.email, address: e.address);
    add(const CustomersLoaded());
  }
  Future<void> _onDeleted(CustomerDeleted e, Emitter<CustomerState> emit) async {
    await _repo.delete(e.localId);
    add(const CustomersLoaded());
  }

  @override
  Future<void> close() { _sub?.cancel(); return super.close(); }
}
