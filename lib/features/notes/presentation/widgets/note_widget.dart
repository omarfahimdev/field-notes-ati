import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_extensions.dart';
import '../../../../core/utils/widgets/custom_inkwell_button.dart';
import '../../domain/field_note.dart';
import 'status_chip.dart';

class NoteCard extends StatelessWidget {
  final FieldNote note;
  final VoidCallback onTap;
  const NoteCard({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final dt = note.occurredAt;
    final time = dt == null ? '' : '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
    return MyInkWellButton(
      onTap: onTap,
      backgroundColor: colorScheme.surfaceContainerLowest,
      decoration: BoxDecoration(border: Border.all(color: Colors.black87.withValues(alpha: 0.1)), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [StatusChip(status: note.status), Text(time, style: const TextStyle(fontSize: 10))]),
        const SizedBox(height: 6),
        Text(note.title.isEmpty ? '(Untitled)' : note.title, style: textTheme.titleSmall),
        const SizedBox(height: 2),
        Text('${note.site.name} · ${note.site.customer.fullName}', style: textTheme.bodySmall),
        const SizedBox(height: 6),
        Row(children: [
          Icon(note.hasLocation ? Icons.place_rounded : Icons.place_outlined, size: 13, color: note.hasLocation ? colorScheme.primary : colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Expanded(child: Text(note.hasLocation ? note.location!.locationSummary : 'No location', maxLines: 1, overflow: TextOverflow.ellipsis, style: textTheme.labelSmall?.copyWith(fontSize: 11))),
          if (note.hasPhoto) ...[Icon(Icons.image_outlined, size: 13, color: colorScheme.onSurfaceVariant), const SizedBox(width: 4), Text('Photo', style: textTheme.labelSmall?.copyWith(fontSize: 11))],
        ]),
      ]),
    );
  }
}
