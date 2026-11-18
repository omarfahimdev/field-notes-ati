import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  final int count;

  const CounterState({this.count = 0});

  // Helper copyWith method to easily update specific fields
  CounterState copyWith({int? count}) {
    return CounterState(count: count ?? this.count);
  }

  @override
  List<Object> get props => [count];
}
