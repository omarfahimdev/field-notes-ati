import 'package:flutter/material.dart';

/// Builds the full Material 3 type scale (15 styles) on Inter, colored
/// from the given `ColorScheme`. Defining the complete scale — not just
/// the 3-4 sizes a screen happens to use — matters because built-in
/// widgets (AppBar title, Chip label, Dialog title, ListTile subtitle...)
/// pick their text style from specific slots in this scale automatically.
/// Leaving slots undefined means those widgets silently fall back to
/// Flutter's default Roboto-based scale, which is how apps end up with
/// one font everywhere except three unstyled corners nobody notices
/// until a designer does.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  static TextTheme textTheme(ColorScheme colorScheme) {
    final base = TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w700, letterSpacing: -0.25),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w700),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.4),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.4),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.2),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.1),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.2),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.3),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.4),
    ).apply(fontFamily: fontFamily, bodyColor: colorScheme.onSurface, displayColor: colorScheme.onSurface);

    // `.apply` doesn't let bodySmall/labelMedium/labelSmall opt into the
    // slightly muted "secondary text" color the way onSurfaceVariant is
    // meant to be used — set those explicitly.
    return base.copyWith(
      bodySmall: base.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
      labelMedium: base.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
    );
  }
}
