import 'package:flutter/material.dart';

import '../../domain/note_status.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final NoteStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: status.containerColor(context),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: status.color(context).withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(color: status.color(context), shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: status.color(context)),
          ),
        ],
      ),
    );
  }
}
