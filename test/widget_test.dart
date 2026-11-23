// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:field_notes/app.dart';
import 'package:field_notes/core/network/api_client.dart';
import 'package:field_notes/core/storage/local_storage.dart';
import 'package:field_notes/core/sync/sync_service.dart';
import 'package:field_notes/features/auth/application/auth_bloc.dart';
import 'package:field_notes/features/auth/data/auth_repository.dart';
import 'package:field_notes/features/customers/application/customer_bloc.dart';
import 'package:field_notes/features/customers/data/customer_repository.dart';
import 'package:field_notes/features/notes/application/note_bloc.dart';
import 'package:field_notes/features/notes/data/note_repository.dart';
import 'package:field_notes/features/settings/application/settings_cubit.dart';
import 'package:field_notes/features/settings/data/settings_repository.dart';
import 'package:field_notes/features/sites/application/site_bloc.dart';
import 'package:field_notes/features/sites/data/site_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    
    final storage = LocalStorage(); await storage.init();
    final api = ApiClient(storage); final sync = SyncService(storage, api);
    final authRepo = AuthRepository(api, storage);
    final customerRepo = CustomerRepository(storage, sync);
    final siteRepo = SiteRepository(storage, sync);
    final noteRepo = NoteRepository(storage, sync);
    final settingsRepo = SettingsRepository(storage);
    await tester.pumpWidget(MultiRepositoryProvider(providers: [
      RepositoryProvider.value(value: storage), RepositoryProvider.value(value: api), RepositoryProvider.value(value: sync),
      RepositoryProvider.value(value: authRepo), RepositoryProvider.value(value: customerRepo), RepositoryProvider.value(value: siteRepo), RepositoryProvider.value(value: noteRepo), RepositoryProvider.value(value: settingsRepo),
    ], child: MultiBlocProvider(providers: [
      BlocProvider(create: (_)=>AuthBloc(authRepo)..add(const AuthStarted())),
      BlocProvider(create: (_)=>CustomerBloc(customerRepo, sync)..add(const CustomersLoaded())),
      BlocProvider(create: (_)=>SiteBloc(siteRepo, sync)..add(const SitesLoaded())),
      BlocProvider(create: (_)=>NoteBloc(noteRepo, sync)..add(const NotesLoaded())),
      BlocProvider(create: (_)=>SettingsCubit(settingsRepo)),
    ], child: const App())));


    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
