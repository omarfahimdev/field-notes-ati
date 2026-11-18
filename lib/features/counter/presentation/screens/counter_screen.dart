import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/bloc/counter_bloc.dart';
import '../../application/bloc/counter_event.dart';
import '../../application/bloc/counter_state.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLoC Counter Example')),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Text('Count: ${state.count}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold));
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: () => context.read<CounterBloc>().add(CounterIncrementPressed()),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: () => context.read<CounterBloc>().add(CounterDecrementPressed()),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
