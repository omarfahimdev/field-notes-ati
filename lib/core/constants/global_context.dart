import 'package:flutter/material.dart';

abstract class GlobalContext {
  GlobalContext._();

  // ── Global Keys ─────────────────────────────────────────────────────────────
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // ── Context Accessors ───────────────────────────────────────────────────────
  static BuildContext get context {
    final context = navigatorKey.currentContext;
    if (context == null) {
      throw FlutterError(
        'GlobalContext is not available.\n'
        'Ensure your MaterialApp/CupertinoApp assigns navigatorKey: GlobalContext.navigatorKey',
      );
    }
    return context;
  }

  /// Safe getter for the current [OverlayContext]. Returns `null` if unmounted or unavailable.
  static BuildContext? get overlayContext => navigatorKey.currentState?.overlay?.context;

  /// Returns whether a valid root [BuildContext] is currently attached to the key.
  static bool get hasContext => navigatorKey.currentContext != null;

  // ── Global SnackBar Utilities ───────────────────────────────────────────────

  /// Displays a [SnackBar]. Clears existing active/queued snackbar instantly
  /// to prevent UI queue stalling when multiple actions are triggered rapidly.
  static void showSnackBar(SnackBar snackBar) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;
    messenger.clearSnackBars();
    messenger.showSnackBar(snackBar);
  }

  /// Instantly dismisses all active or queued snackbar.
  static void clearSnackBars() => scaffoldMessengerKey.currentState?.clearSnackBars();

  /// Safely hides the current snackbar.
  static void hideCurrentSnackBar() => scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

  // ── Global Dialog & Sheet Helpers ──────────────────────────────────────────

  /// Triggers a global modal dialog without requiring local UI [BuildContext].
  static Future<T?> showAppDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: builder,
    );
  }

  /// Triggers a global modal bottom sheet without requiring local UI [BuildContext].
  static Future<T?> showAppBottomSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    Color? backgroundColor,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      shape: shape,
      builder: builder,
    );
  }

  // ── Soft Keyboard Management ────────────────────────────────────────────────

  /// Globally unfocused active text input nodes and dismisses the soft keyboard.
  static void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
