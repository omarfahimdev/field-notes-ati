import 'package:flutter/material.dart';

import 'app_typography.dart';
import 'color_builders/semantic_colors.dart';
import 'color_schemes.dart';
import 'theme_builders/app_bar_theme.dart';
import 'theme_builders/input_decoration_theme.dart';

/// `main.dart`.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(colorScheme: AppColorSchemes.light, semanticColors: AppSemanticColors.light);

  static ThemeData get dark => _build(colorScheme: AppColorSchemes.dark, semanticColors: AppSemanticColors.dark);

  static ThemeData _build({required ColorScheme colorScheme, required AppSemanticColors semanticColors}) {
    final textTheme = AppTypography.textTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      iconTheme: IconThemeData(color: colorScheme.primary, size: 18),

      progressIndicatorTheme: ProgressIndicatorThemeData(strokeWidth: 2),

      // Component themes — each one lives in its own file under
      // component_themes/ so this composition stays readable as the
      // app grows past a dozen customized widgets.
      appBarTheme: AppBarThemeBuilder.build(colorScheme, textTheme),
      // filledButtonTheme: ButtonThemeBuilder.filled(colorScheme),
      // elevatedButtonTheme: ButtonThemeBuilder.elevated(colorScheme),
      // outlinedButtonTheme: ButtonThemeBuilder.outlined(colorScheme),
      // textButtonTheme: ButtonThemeBuilder.text(colorScheme),
      // iconButtonTheme: ButtonThemeBuilder.icon(colorScheme),
      inputDecorationTheme: InputDecorationThemeBuilder.build(colorScheme, textTheme),
      // cardTheme: CardThemeBuilder.build(colorScheme),
      // chipTheme: ChipThemeBuilder.build(colorScheme, textTheme),
      // bottomSheetTheme: BottomSheetThemeBuilder.build(colorScheme),
      // snackBarTheme: SnackBarThemeBuilder.build(colorScheme, textTheme),
      // dialogTheme: DialogThemeBuilder.build(colorScheme),
      // checkboxTheme: SelectionControlThemeBuilder.checkbox(colorScheme),
      // switchTheme: SelectionControlThemeBuilder.switchTheme(colorScheme),
      // radioTheme: SelectionControlThemeBuilder.radio(colorScheme),
      // `ActionIconThemeData` lives on `ThemeData` directly (not
      // `AppBarTheme`), which is why it's set here rather than inside
      // app_bar_theme.dart. Uncomment once the AppBackButton import
      // above is pointed at the right path.
      // actionIconTheme: ActionIconThemeData(
      //   backButtonIconBuilder: (context) => const AppBackButton(),
      // ),

      // Extensions carry anything `ColorScheme`/`TextTheme` don't model
      // — currently just the success/warning/info semantic colors.
      // Add future cross-cutting tokens (spacing, radii) as additional
      // extensions here rather than as loose top-level constants.
      extensions: [semanticColors],
    );
  }
}
