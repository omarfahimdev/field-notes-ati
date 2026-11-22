import 'package:field_notes/core/theme/app_theme_extensions.dart';
import 'package:field_notes/core/utils/widgets/custom_inkwell_button.dart';
import 'package:field_notes/features/notes/domain/field_note.dart';
import 'package:field_notes/features/notes/domain/note_status.dart';
import 'package:field_notes/features/notes/presentation/widgets/status_chip.dart';
import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  final FieldNote note;
  final VoidCallback onTap;
  const new({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return MyInkWellButton(
      onTap: onTap,
      backgroundColor: colorScheme.surfaceContainerLowest,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: Colors.black87)],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusChip(status: NoteStatus.completed),
              Text('23:02', style: TextStyle(fontSize: 10)),
            ],
          ),
          Text('Quarterly Rack Inspection', style: textTheme.titleSmall),
          Text('Depot Bay 4 Northgate Logistics', style: textTheme.bodySmall),
          SizedBox(height: 4),
          _buildPhotoAndLocationStatus(note, colorScheme, textTheme),
        ],
      ),
    );
  }

  Widget _buildPhotoAndLocationStatus(FieldNote note, ColorScheme colorScheme, TextTheme textTheme) => Row(
    children: [
      Icon(
        note.hasLocation ? Icons.place_rounded : Icons.place_outlined,
        size: 13,
        color: note.hasLocation ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      const SizedBox(width: 4),
      Expanded(
        child: Text(
          note.hasLocation ? (note.location?.locationLabel ?? 'Location pinned') : 'No location',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelSmall?.copyWith(fontSize: 11),
        ),
      ),
      if (note.hasPhoto) ...[
        Icon(Icons.image_outlined, size: 13, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text('Photo', style: textTheme.labelSmall?.copyWith(fontSize: 11)),
      ],
    ],
  );
}
