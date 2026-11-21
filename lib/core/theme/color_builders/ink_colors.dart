import 'package:flutter/material.dart';

@immutable
class InkColors {
  final Color primary;
  final Color muted;
  final Color faint;

  const InkColors({required this.primary, required this.muted, required this.faint});

  const InkColors.light()
    : primary = const Color(0xFF241B15),
      muted = const Color(0xFF6B5F55),
      faint = const Color(0xFFA79A8D);

  const InkColors.dark()
    : primary = const Color(0xFFF3ECE3),
      muted = const Color(0xFFC2B6A8),
      faint = const Color(0xFF8B7E70);

  static InkColors lerp(InkColors a, InkColors b, double t) => InkColors(
    primary: Color.lerp(a.primary, b.primary, t)!,
    muted: Color.lerp(a.muted, b.muted, t)!,
    faint: Color.lerp(a.faint, b.faint, t)!,
  );
}
