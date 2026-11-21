import 'package:field_notes/core/constants/app_info.dart';
import 'package:field_notes/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';

import 'core/constants/global_context.dart';
import 'core/theme/app_theme.dart';

class App extends StatefulWidget {
  const new({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.name,
      debugShowCheckedModeBanner: false,
      // ========== THEME
      themeMode: ThemeMode.light,
      themeAnimationDuration: const Duration(milliseconds: 450),
      themeAnimationCurve: Curves.easeInOutCubic,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: LoginScreen(),
      // ========== BUILDER
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink(); // Null-guard for initial routing asserts

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
        );
      },
      scaffoldMessengerKey: GlobalContext.scaffoldMessengerKey,
    );
  }
}
