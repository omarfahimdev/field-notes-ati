import 'package:field_notes/core/theme/app_theme_extensions.dart';
import 'package:field_notes/core/utils/widgets/custom_inkwell_button.dart';
import 'package:field_notes/features/customers/domain/customer.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimension.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key, required this.customer, this.onTap});

  final Customer customer;
  final VoidCallback? onTap;

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
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: Text(
              _initials(customer.fullName),
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  customer.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(fontSize: 15.5),
                ),
                Row(
                  children: [
                    _CountPill(icon: Icons.location_on_outlined, label: ' 2 sites'),
                    const SizedBox(width: 6),
                    _CountPill(icon: Icons.description_outlined, label: '4 notes'),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 20, color: colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase();
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: scheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
