import 'package:flutter/material.dart';

import 'color_builders/semantic_colors.dart';

extension AppColorSchemeX on ColorScheme {
  /// Access semantic tokens via ColorScheme.
  /// Note: This resolves purely based on brightness (does not lerp during theme animation).
  AppSemanticColors get semantic => brightness == Brightness.dark ? AppSemanticColors.dark : AppSemanticColors.light;
}

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);

  /// Theme.of(context).colorScheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Theme.of(context).textTheme
  TextTheme get textTheme => theme.textTheme;

  /// Context-aware semantic tokens that properly support lerp and subtree overrides.
  /// Defaults to dark or light preset based on active brightness if not registered.
  AppSemanticColors get colors {
    return theme.extension<AppSemanticColors>() ?? AppSemanticColors.fromBrightness(colorScheme.brightness);
  }

  /// Convenient alias matching your requested pattern
  AppSemanticColors get semantics => colors;
}
