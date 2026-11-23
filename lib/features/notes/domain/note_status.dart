import 'package:flutter/material.dart';

enum NoteStatus {
  draft('DRAFT', 'Draft', 'Captured but not started'),
  inProgress('IN_PROGRESS', 'In progress', 'Work under way on site'),
  completed('COMPLETED', 'Completed', 'Visit finished'),
  followUp('FOLLOW_UP', 'Follow-up needed', 'Someone needs to return');

  const NoteStatus(this.apiValue, this.label, this.description);

  final String apiValue;
  final String label;
  final String description;

  IconData get icon {
    switch (this) {
      case NoteStatus.draft:
        return Icons.edit_note_rounded;
      case NoteStatus.inProgress:
        return Icons.timelapse_rounded;
      case NoteStatus.completed:
        return Icons.check_circle_outline_rounded;
      case NoteStatus.followUp:
        return Icons.flag_outlined;
    }
  }

  Color color(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case NoteStatus.draft:
        return isDark ? const Color(0xFFC2CCC4) : const Color(0xFF4A5249);
      case NoteStatus.inProgress:
        return isDark ? const Color(0xFFF1C079) : Color(0xFFD98218);
      case NoteStatus.completed:
        return isDark ? const Color(0xFF97DDA9) : Color(0xFF1F7A4C);
      case NoteStatus.followUp:
        return isDark ? const Color(0xFFFFB4A9) : Color(0xFFC2412D);
    }
  }

  Color containerColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case NoteStatus.draft:
        return isDark ? const Color(0xFF2A332C) : const Color(0xFFEDF0EA);
      case NoteStatus.inProgress:
        return isDark ? const Color(0xFF3A2C16) : Color(0xFFFFF3DC);
      case NoteStatus.completed:
        return isDark ? const Color(0xFF143021) : const Color(0xFFE3F1E4);
      case NoteStatus.followUp:
        return isDark ? const Color(0xFF3C1D19) : Color(0xFFFDE8E4);
    }
  }

  static NoteStatus fromJson(Object? value, {NoteStatus fallback = NoteStatus.draft}) {
    final raw = value?.toString();
    if (raw == null || raw.isEmpty) return fallback;
    for (final status in NoteStatus.values) {
      if (status.apiValue == raw || status.name == raw) return status;
    }
    // API values: draft, inProgress, completed, followUp
    switch (raw) {
      case 'draft': return NoteStatus.draft;
      case 'inProgress': return NoteStatus.inProgress;
      case 'completed': return NoteStatus.completed;
      case 'followUp': return NoteStatus.followUp;
    }
    return fallback;
  }

  String get apiName {
    switch (this) {
      case NoteStatus.draft: return 'draft';
      case NoteStatus.inProgress: return 'inProgress';
      case NoteStatus.completed: return 'completed';
      case NoteStatus.followUp: return 'followUp';
    }
  }
}
