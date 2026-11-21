import 'package:flutter/material.dart';

import 'gradient_colors.dart';
import 'ink_colors.dart';
import 'status_colors.dart';

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  // Brand Accents
  final Color brandPrimary;
  final Color brandSecondary;
  final Color brandTertiary;

  // Statuses
  final StatusColors success;
  final StatusColors warning;
  final StatusColors info;

  // Neutrals & Structure
  final Color canvas;
  final Color surface;
  final Color surfaceRaised;
  final Color hairline;

  // Content
  final InkColors ink;
  final Color danger;

  // Gradients
  final GradientColors gradients;

  const AppSemanticColors({
    required this.brandPrimary,
    required this.brandSecondary,
    required this.brandTertiary,
    required this.success,
    required this.warning,
    required this.info,
    required this.canvas,
    required this.surface,
    required this.surfaceRaised,
    required this.hairline,
    required this.ink,
    required this.danger,
    required this.gradients,
  });

  // Backward-compatibility Getters
  Color get emberTerracotta => brandPrimary;
  Color get curdGold => brandSecondary;
  Color get riverTeal => brandTertiary;

  // ---------------------------------------------------------------------------
  // Presets
  // ---------------------------------------------------------------------------
  static final light = AppSemanticColors(
    brandPrimary: Color(0xFFC1652F),
    brandSecondary: Color(0xFFE3A73B),
    brandTertiary: Color(0xFF276B69),
    success: StatusColors.successDark(),
    warning: StatusColors.warningDark(),
    info: StatusColors.infoDark(),
    ink: InkColors.light(),
    canvas: Color(0xFFF8F5EF),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFDF9),
    hairline: Color(0xFFE7DFD3),
    danger: Color(0xFFB3402A),
    //
    gradients: GradientColors.light(),
  );

  static final dark = AppSemanticColors(
    brandPrimary: Color(0xFFFFD4BB),
    brandSecondary: Color(0xFFE3A73B),
    brandTertiary: Color(0xFF276B69),
    success: StatusColors.successLight(),
    warning: StatusColors.warningLight(),
    info: StatusColors.infoLight(),
    ink: InkColors.dark(),
    canvas: Color(0xFF17130F),
    surface: Color(0xFF211C16),
    surfaceRaised: Color(0xFF2A241D),
    hairline: Color(0xFF3A322A),
    danger: Color(0xFFE0725A),
    //
    gradients: GradientColors.dark(),
  );

  factory AppSemanticColors.fromBrightness(Brightness brightness) => brightness == Brightness.dark ? dark : light;

  @override
  AppSemanticColors copyWith() => this;

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      brandTertiary: Color.lerp(brandTertiary, other.brandTertiary, t)!,
      success: StatusColors.lerp(success, other.success, t),
      warning: StatusColors.lerp(warning, other.warning, t),
      info: StatusColors.lerp(info, other.info, t),
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      ink: InkColors.lerp(ink, other.ink, t),
      danger: Color.lerp(danger, other.danger, t)!,
      gradients: GradientColors.lerp(gradients, other.gradients, t),
    );
  }
}
