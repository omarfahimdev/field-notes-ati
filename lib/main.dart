import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'core/storage/local_storage.dart';
import 'core/sync/sync_service.dart';
import 'features/auth/application/auth_bloc.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/customers/application/customer_bloc.dart';
import 'features/customers/data/customer_repository.dart';
import 'features/notes/application/note_bloc.dart';
import 'features/notes/data/note_repository.dart';
import 'features/settings/application/settings_cubit.dart';
import 'features/settings/data/settings_repository.dart';
import 'features/sites/application/site_bloc.dart';
import 'features/sites/data/site_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = LocalStorage();
  await storage.init();
  final api = ApiClient(storage);
  final sync = SyncService(storage, api);
  final authRepo = AuthRepository(api, storage);
  final customerRepo = CustomerRepository(storage, sync);
  final siteRepo = SiteRepository(storage, sync);
  final noteRepo = NoteRepository(storage, sync);
  final settingsRepo = SettingsRepository(storage);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: storage),
        RepositoryProvider.value(value: api),
        RepositoryProvider.value(value: sync),
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: customerRepo),
        RepositoryProvider.value(value: siteRepo),
        RepositoryProvider.value(value: noteRepo),
        RepositoryProvider.value(value: settingsRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authRepo)..add(const AuthStarted())),
          BlocProvider(create: (_) => CustomerBloc(customerRepo, sync)..add(const CustomersLoaded())),
          BlocProvider(create: (_) => SiteBloc(siteRepo, sync)..add(const SitesLoaded())),
          BlocProvider(create: (_) => NoteBloc(noteRepo, sync)..add(const NotesLoaded())),
          BlocProvider(create: (_) => SettingsCubit(settingsRepo)),
        ],
        child: const App(),
      ),
    ),
  );
}
