library;

/// ============== CUSTOM INKWELL BUTTON ==============

import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

class MyInkWellButton extends StatelessWidget {
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final Widget child;
  final DecorationImage? image;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? splashColor;
  final Color? highlightColor;
  final BoxConstraints? constraints;
  final BoxBorder? border;
  final BoxDecoration? decoration;

  const MyInkWellButton({
    super.key,
    this.backgroundColor,
    this.borderRadius = AppConstants.borderRadius,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    required this.child,
    this.image,
    this.padding,
    this.margin,
    this.splashColor,
    this.highlightColor,
    this.constraints,
    this.border,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius =
        borderRadius ?? (decoration?.borderRadius is BorderRadius ? decoration!.borderRadius as BorderRadius : null);

    final effectiveDecoration = (decoration ?? const BoxDecoration()).copyWith(
      color: backgroundColor ?? decoration?.color,
      borderRadius: effectiveRadius ?? decoration?.borderRadius,
      border: border ?? decoration?.border,
      image: image ?? decoration?.image,
    );

    Widget button = Material(
      color: Colors.transparent,
      borderRadius: effectiveRadius,
      child: Ink(
        decoration: effectiveDecoration,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
          borderRadius: effectiveRadius,
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: constraints != null ? ConstrainedBox(constraints: constraints!, child: child) : child,
          ),
        ),
      ),
    );

    if (margin != null) {
      button = Padding(padding: margin!, child: button);
    }

    return button;
  }
}
