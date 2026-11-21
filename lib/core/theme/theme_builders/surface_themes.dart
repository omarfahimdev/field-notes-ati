import 'package:flutter/material.dart';

class CardThemeBuilder {
  CardThemeBuilder._();

  static CardThemeData build(ColorScheme colorScheme) {
    return CardThemeData(
      color: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
    );
  }
}

/// Chip theming — covers filter chips, status chips, category tags.
class ChipThemeBuilder {
  ChipThemeBuilder._();

  static ChipThemeData build(ColorScheme colorScheme, TextTheme textTheme) {
    return ChipThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      selectedColor: colorScheme.primary,
      disabledColor: colorScheme.onSurface.withValues(alpha: 0.08),
      labelStyle: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
      secondaryLabelStyle: textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

/// Bottom sheet theming — the rounded-top sheet used by every filter/
/// picker/confirmation sheet across the app.
class BottomSheetThemeBuilder {
  BottomSheetThemeBuilder._();

  static BottomSheetThemeData build(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: colorScheme.surface,
      elevation: 0,
      modalElevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      clipBehavior: Clip.antiAlias,
    );
  }
}

/// SnackBar theming — floating, rounded, matching the success/error
/// snackbars used throughout the form screens.
class SnackBarThemeBuilder {
  SnackBarThemeBuilder._();

  static SnackBarThemeData build(ColorScheme colorScheme, TextTheme textTheme) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onInverseSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

/// Dialog theming — matches the rounded `AlertDialog`s already used for
/// delete confirmations across the product/category screens.
class DialogThemeBuilder {
  DialogThemeBuilder._();

  static DialogThemeData build(ColorScheme colorScheme) {
    return DialogThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
