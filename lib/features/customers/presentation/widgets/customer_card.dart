import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimension.dart';
import '../../../../core/theme/app_theme_extensions.dart';
import '../../../../core/utils/widgets/custom_inkwell_button.dart';
import '../../domain/customer.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key, required this.customer, this.onTap, this.siteCount = 0, this.noteCount = 0});
  final Customer customer; final VoidCallback? onTap; final int siteCount; final int noteCount;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme; final textTheme = context.textTheme;
    return MyInkWellButton(onTap: onTap, backgroundColor: scheme.surfaceContainerLowest, decoration: BoxDecoration(border: Border.all(color: Colors.black87.withValues(alpha: 0.1)), borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.all(12), child: Row(children: [
      Container(width: 46, height: 46, alignment: Alignment.center, decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(AppRadius.sm)), child: Text(_initials(customer.fullName), style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w700))),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(customer.fullName, maxLines: 1, overflow: TextOverflow.ellipsis, style: textTheme.titleMedium?.copyWith(fontSize: 15.5)),
        const SizedBox(height: 4),
        Text('$siteCount sites · $noteCount notes', style: textTheme.bodySmall),
      ])),
      Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
    ]));
  }
  String _initials(String name) { final parts = name.trim().split(RegExp(r'\s+')).where((p)=>p.isNotEmpty).toList(); if (parts.isEmpty) return '?'; if (parts.length==1) return parts.first[0].toUpperCase(); return (parts.first[0]+parts.last[0]).toUpperCase(); }
}
