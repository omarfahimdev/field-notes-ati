import 'package:bloc/bloc.dart';

import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<CounterIncrementPressed>(_onIncrement);
    on<CounterDecrementPressed>(_onDecrement);
  }

  void _onIncrement(CounterIncrementPressed event, Emitter<CounterState> emit) {
    emit(state.copyWith(count: state.count + 1));
  }

  void _onDecrement(CounterDecrementPressed event, Emitter<CounterState> emit) {
    emit(state.copyWith(count: state.count - 1));
  }
}
