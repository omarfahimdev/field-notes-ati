part of 'customer_bloc.dart';

sealed class CustomerEvent extends Equatable {
  const CustomerEvent();
  @override
  List<Object?> get props => [];
}
class CustomersLoaded extends CustomerEvent { const CustomersLoaded(); }
class CustomerAdded extends CustomerEvent {
  final String fullName, phone, email; final String? address;
  const CustomerAdded({required this.fullName, required this.phone, required this.email, this.address});
}
class CustomerUpdated extends CustomerEvent {
  final String localId, fullName, phone, email; final String? address;
  const CustomerUpdated({required this.localId, required this.fullName, required this.phone, required this.email, this.address});
}
class CustomerDeleted extends CustomerEvent { final String localId; const CustomerDeleted(this.localId); }
