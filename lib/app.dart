import 'package:flutter/material.dart';

import 'app/auth_gate.dart';
import 'core/constants/app_info.dart';
import 'core/constants/global_context.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.name,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      navigatorKey: GlobalContext.navigatorKey,
      scaffoldMessengerKey: GlobalContext.scaffoldMessengerKey,
      home: const AuthGate(),
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
        );
      },
    );
  }
}
