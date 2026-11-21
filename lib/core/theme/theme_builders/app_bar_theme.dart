import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

class AppBarThemeBuilder {
  AppBarThemeBuilder._();

  static AppBarTheme build(ColorScheme colorScheme, TextTheme textTheme) {
    return AppBarTheme(
      // backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      // titleSpacing: 0,
      // titleSpacing: 14,
      actionsPadding: const EdgeInsets.only(right: AppConstants.screenMarginPoint),
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      // actionIconTheme (the custom AppBackButton) is set once on
      // ThemeData directly in app_theme.dart, not here — Flutter's
      // ActionIconThemeData lives at the ThemeData level, not AppBarTheme.
    );
  }
}
