import 'package:field_notes/app.dart';
import 'package:field_notes/features/counter/application/bloc/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider(create: (context) => CounterBloc(), child: const App()));
}
