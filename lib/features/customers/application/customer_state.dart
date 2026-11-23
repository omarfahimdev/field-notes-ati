part of 'customer_bloc.dart';

class CustomerState extends Equatable {
  final List<Customer> items;
  final bool loading;
  const CustomerState({this.items = const [], this.loading = true});
  CustomerState copyWith({List<Customer>? items, bool? loading}) => CustomerState(items: items ?? this.items, loading: loading ?? this.loading);
  @override
  List<Object?> get props => [items, loading];
}
