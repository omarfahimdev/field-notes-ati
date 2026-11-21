import 'package:flutter/material.dart';

class AppConstants {
  static const screenMarginPoint = 20.0;

  static EdgeInsets screenMargin({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? vertical,
    double? horizontal,
  }) => EdgeInsets.fromLTRB(
    left ?? horizontal ?? screenMarginPoint,
    top ?? vertical ?? 0,
    right ?? horizontal ?? screenMarginPoint,
    bottom ?? vertical ?? 0,
  );
}
