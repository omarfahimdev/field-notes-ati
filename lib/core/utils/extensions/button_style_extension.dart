import 'package:flutter/material.dart';

extension ButtonLoadingExtension on ButtonStyleButton {
  /// Basic Loading: Just a CircularProgressIndicator
  Widget withLoading(bool isLoading) => _buildButton(isLoading, _defaultLoader());

  /// Custom Loading: ProgressIndicator + Animated Text Row
  Widget withLoadingLabel(bool isLoading, {required String label, TextStyle? textStyle}) =>
      _buildButton(isLoading, _rowLoader(_defaultLoader(), label, textStyle));

  /// Custom Loading: Fully custom widget + Optional Label
  Widget withCustomLoading(bool isLoading, {required Widget loader, String? label, TextStyle? textStyle}) =>
      _buildButton(isLoading, label != null ? _rowLoader(loader, label, textStyle) : loader);

  /// Clones the button while preserving type and disabling all interaction fields
  Widget _buildButton(bool isLoading, Widget loader) {
    if (!isLoading) return this;

    // Force all interactions to null when loading to ensure the button is "Disabled"
    final VoidCallback? resolveOnPressed = null;
    final VoidCallback? resolveOnLongPress = null;
    final ValueChanged<bool>? resolveOnHover = null;
    final ValueChanged<bool>? resolveOnFocusChange = null;
    final Widget resolveChild = loader;

    return switch (this) {
      FilledButton() => FilledButton(
        onPressed: resolveOnPressed,
        onLongPress: resolveOnLongPress,
        onHover: resolveOnHover,
        onFocusChange: resolveOnFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        child: resolveChild,
      ),
      ElevatedButton() => ElevatedButton(
        onPressed: resolveOnPressed,
        onLongPress: resolveOnLongPress,
        onHover: resolveOnHover,
        onFocusChange: resolveOnFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        child: resolveChild,
      ),
      OutlinedButton() => OutlinedButton(
        onPressed: resolveOnPressed,
        onLongPress: resolveOnLongPress,
        onHover: resolveOnHover,
        onFocusChange: resolveOnFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        child: resolveChild,
      ),
      TextButton() => TextButton(
        onPressed: resolveOnPressed,
        onLongPress: resolveOnLongPress,
        onHover: resolveOnHover,
        onFocusChange: resolveOnFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        child: resolveChild,
      ),
      _ => this,
    };
  }

  /// Internal helper to build the horizontal loader layout
  Widget _rowLoader(Widget loader, String label, TextStyle? textStyle) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        loader,
        const SizedBox(width: 12),
        // We use a Stack to keep the label width stable
        Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Static text (invisible) to define the minimum width
            // We add extra space for 3 dots so the width never changes
            Opacity(
              opacity: 0,
              child: Text('$label...', style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
            // 2. The actual animated label sitting on top
            // Positioned(
            //   left: 0,
            //   child: LoadingLabel(text: label, style: textStyle),
            // ),
          ],
        ),
      ],
    );
  }

  /// Internal helper for a theme-aware CircularProgressIndicator
  Widget _defaultLoader() => SizedBox(
    height: 18,
    width: 18,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      valueColor: AlwaysStoppedAnimation<Color?>((this is OutlinedButton || this is TextButton) ? null : Colors.white),
    ),
  );
}
