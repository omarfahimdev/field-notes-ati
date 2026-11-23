import 'package:field_notes/core/theme/app_theme_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimension.dart';
import '../../domain/note_status.dart';

/// Bottom sheet used both for a note's status and for the saved default in
/// Settings, so the two never drift apart visually.
Future<NoteStatus?> showStatusPicker(
  BuildContext context, {
  required NoteStatus selected,
  String title = 'Note status',
  String subtitle = 'What state is this visit in right now?',
}) {
  return showModalBottomSheet<NoteStatus>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _StatusPickerSheet(selected: selected, title: title, subtitle: subtitle),
  );
}

class _StatusPickerSheet extends StatelessWidget {
  const _StatusPickerSheet({required this.selected, required this.title, required this.subtitle});

  final NoteStatus selected;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle, style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            for (final status in NoteStatus.values) ...[
              _StatusOption(
                status: status,
                isSelected: status == selected,
                onTap: () => Navigator.of(context).pop(status),
              ),
              if (status != NoteStatus.values.last) const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.xs),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          ],
        ),
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({required this.status, required this.isSelected, required this.onTap});

  final NoteStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.all(AppSpacing.md + 2),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.35) : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: isSelected ? colorScheme.primary : colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: status.containerColor(context), shape: BoxShape.circle),
              child: Icon(status.icon, size: 18, color: status.color(context)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.label,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 1),
                  Text(status.description, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle_rounded, size: 20, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
