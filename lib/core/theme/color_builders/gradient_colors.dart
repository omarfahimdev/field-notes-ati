import 'package:flutter/material.dart';

@immutable
class GradientColors {
  final LinearGradient primary;
  final LinearGradient hero;
  final LinearGradient heroVibrant;
  final LinearGradient success;
  final LinearGradient warning;

  const GradientColors({
    required this.primary,
    required this.hero,
    required this.heroVibrant,
    required this.success,
    required this.warning,
  });

  // ---------------------------------------------------------------------------
  // Light Palette Named Constructor
  // ---------------------------------------------------------------------------
  const GradientColors.light()
    : primary = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
      ),
      hero = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4338CA), Color(0xFF6D28D9), Color(0xFF0EA5E9)],
      ),
      heroVibrant = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4338CA), Color(0xFF6D28D9), Color(0xFF0EA5E9)],
      ),
      success = const LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF16A34A)]),
      warning = const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)]);

  // ---------------------------------------------------------------------------
  // Dark Palette Named Constructor
  // ---------------------------------------------------------------------------
  const GradientColors.dark()
    : primary = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
      ),
      hero = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1E1B4B), // Indigo 950
          Color(0xFF2E1065), // Purple 950
          Color(0xFF082F49), // Sky 950
        ],
      ),
      heroVibrant = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF312E81), // Indigo 900
          Color(0xFF4C1D95), // Purple 900
          Color(0xFF075985), // Sky 800
        ],
      ),
      success = const LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF16A34A)]),
      warning = const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)]);

  // ---------------------------------------------------------------------------
  // Transition Lerp
  // ---------------------------------------------------------------------------
  static GradientColors lerp(GradientColors a, GradientColors b, double t) => GradientColors(
    primary: LinearGradient.lerp(a.primary, b.primary, t) ?? a.primary,
    hero: LinearGradient.lerp(a.hero, b.hero, t) ?? a.hero,
    heroVibrant: LinearGradient.lerp(a.heroVibrant, b.heroVibrant, t) ?? a.heroVibrant,
    success: LinearGradient.lerp(a.success, b.success, t) ?? a.success,
    warning: LinearGradient.lerp(a.warning, b.warning, t) ?? a.warning,
  );
}
