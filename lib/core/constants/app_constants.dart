import 'package:flutter/material.dart';

class AppConstants {
  static const screenMarginPoint = 10.0;
  static const borderRadiusPoint = 16.0;
  static const apiBaseUrl = 'http://localhost:8080';
  static const tokenKey = 'auth_token';
  static const userKey = 'auth_user';
  static const defaultStatusKey = 'default_note_status';
  static const pendingSyncKey = 'pending_sync_ops';

  static const borderRadius = BorderRadius.all(Radius.circular(borderRadiusPoint));

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
