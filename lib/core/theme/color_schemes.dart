import 'package:flutter/material.dart';

/// Single source of brand color. Both light and dark schemes are
/// derived from the SAME seed — only brightness flips. Using different
/// seeds per brightness (as in the original snippet: deepPurple for
/// light, yellowAccent for dark) means the brand palette itself changes
/// between modes, not just its brightness — almost never what's
/// intended, and it breaks the "same app, different lighting" feel
/// users expect from dark mode. If the two brands are actually meant to
/// differ, that's a design decision worth making explicit rather than
/// a side effect of picking two unrelated seed colors.
///
/// This value matches `AppColors.primary` (0xFF4F46E5) already used
/// across the feature screens, so `Theme.of(context).colorScheme` and
/// the existing custom `AppColors` palette resolve to the same brand
/// color — one less thing to keep in sync while both systems coexist.
const Color kBrandSeed = Color(0xFF4f772d);
// Color(0xFF4F46E5)

/// Wraps `ColorScheme.fromSeed` so `AppTheme` never constructs a scheme
/// inline — one place to swap the seed, add a `.harmonized()` step, or
/// switch to a fully custom `ColorScheme` later without touching
/// `app_theme.dart` or any component theme.
class AppColorSchemes {
  AppColorSchemes._();

  static ColorScheme get light {
    final base = ColorScheme.fromSeed(seedColor: kBrandSeed, brightness: Brightness.light);
    return base.copyWith(
      outlineVariant: base.outlineVariant.withValues(alpha: 0.40), // or withOpacity(0.5)
    );
  }

  static ColorScheme get dark {
    final base = ColorScheme.fromSeed(seedColor: kBrandSeed, brightness: Brightness.dark);
    return base.copyWith(outlineVariant: base.outlineVariant.withValues(alpha: 0.60));
  }
}
