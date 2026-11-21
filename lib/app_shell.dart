// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../features/customers/data/customer_repository.dart';
// import '../features/customers/presentation/customers_bloc.dart';
// import '../features/customers/presentation/screens/customers_screen.dart';
// import '../features/notes/data/note_repository.dart';
// import '../features/notes/presentation/notes_bloc.dart';
// import '../features/notes/presentation/screens/notes_screen.dart';
// import '../features/settings/presentation/screens/settings_screen.dart';
// import '../features/sites/data/site_repository.dart';
// import '../features/sync/presentation/sync_bloc.dart';
// import '../core/events/app_events.dart';

// /// Bottom-navigation shell holding the three hubs. Each tab keeps its own state
// /// in an [IndexedStack], and the notes/customers blocs live here so search and
// /// filters survive tab switches.
// class AppShell extends StatefulWidget {
//   const AppShell({super.key});

//   @override
//   State<AppShell> createState() => _AppShellState();
// }

// class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
//   int _index = 0;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && mounted) {
//       context.read<SyncBloc>().add(
//         const SyncRequested(reason: 'app-resumed'),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => NotesBloc(
//             repository: context.read<NoteRepository>(),
//             sites: context.read<SiteRepository>(),
//             events: context.read<AppEvents>(),
//           )..add(const NotesStarted()),
//         ),
//         BlocProvider(
//           create: (context) => CustomersBloc(
//             repository: context.read<CustomerRepository>(),
//             events: context.read<AppEvents>(),
//           )..add(const CustomersStarted()),
//         ),
//       ],
//       child: Scaffold(
//         body: IndexedStack(
//           index: _index,
//           children: const [
//             NotesScreen(),
//             CustomersScreen(),
//             SettingsScreen(),
//           ],
//         ),
//         bottomNavigationBar: DecoratedBox(
//           decoration: BoxDecoration(
//             color: scheme.surfaceContainerLowest,
//             border: Border(top: BorderSide(color: scheme.outlineVariant)),
//           ),
//           child: NavigationBar(
//             selectedIndex: _index,
//             onDestinationSelected: (index) => setState(() => _index = index),
//             destinations: const [
//               NavigationDestination(
//                 icon: Icon(Icons.description_outlined),
//                 selectedIcon: Icon(Icons.description_rounded),
//                 label: 'Notes',
//               ),
//               NavigationDestination(
//                 icon: Icon(Icons.people_outline_rounded),
//                 selectedIcon: Icon(Icons.people_rounded),
//                 label: 'Customers',
//               ),
//               NavigationDestination(
//                 icon: Icon(Icons.tune_rounded),
//                 selectedIcon: Icon(Icons.tune_rounded),
//                 label: 'Settings',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
