import 'package:flutter/material.dart';

@immutable
class StatusColors {
  final Color base;
  final Color onBase;
  final Color container;
  final Color onContainer;
  final Color border;

  const StatusColors({
    required this.base,
    required this.onBase,
    required this.container,
    required this.onContainer,
    required this.border,
  });

  // ---------------------------------------------------------------------------
  // Success Presets
  // ---------------------------------------------------------------------------
  const StatusColors.successLight()
    : base = const Color(0xFF16A34A),
      onBase = Colors.white,
      container = const Color(0xFFE7F8EE),
      onContainer = const Color(0xFF0F5C2C),
      border = const Color(0xFFA7E3BE);

  const StatusColors.successDark()
    : base = const Color(0xFF4ADE80),
      onBase = const Color(0xFF0A3B1E),
      container = const Color(0xFF14532D),
      onContainer = const Color(0xFFBBF7D0),
      border = const Color(0xFF1F5B39);

  // ---------------------------------------------------------------------------
  // Warning Presets
  // ---------------------------------------------------------------------------
  const StatusColors.warningLight()
    : base = const Color(0xFFF59E0B),
      onBase = Colors.white,
      container = const Color(0xFFFFF6E5),
      onContainer = const Color(0xFF7A4E00),
      border = const Color(0xFFF9D896);

  const StatusColors.warningDark()
    : base = const Color(0xFFFBBF24),
      onBase = const Color(0xFF452B00),
      container = const Color(0xFF78350F),
      onContainer = const Color(0xFFFDE68A),
      border = const Color(0xFF6B5119);

  // ---------------------------------------------------------------------------
  // Info Presets
  // ---------------------------------------------------------------------------
  const StatusColors.infoLight()
    : base = const Color(0xFF3B82F6),
      onBase = Colors.white,
      container = const Color(0xFFEAF2FF),
      onContainer = const Color(0xFF1E3A8A),
      border = const Color(0xFFB7D3FC);

  const StatusColors.infoDark()
    : base = const Color(0xFF60A5FA),
      onBase = const Color(0xFF0B2A5C),
      container = const Color(0xFF1E3A8A),
      onContainer = const Color(0xFFBFDBFE),
      border = const Color(0xFF244B7A);

  // ---------------------------------------------------------------------------
  // Theme Transition
  // ---------------------------------------------------------------------------
  static StatusColors lerp(StatusColors a, StatusColors b, double t) => StatusColors(
    base: Color.lerp(a.base, b.base, t)!,
    onBase: Color.lerp(a.onBase, b.onBase, t)!,
    container: Color.lerp(a.container, b.container, t)!,
    onContainer: Color.lerp(a.onContainer, b.onContainer, t)!,
    border: Color.lerp(a.border, b.border, t)!,
  );
}
