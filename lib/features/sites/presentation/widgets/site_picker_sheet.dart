import 'package:field_notes/features/sites/domain/site.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimension.dart';
import '../../../../core/utils/widgets/app_empty_state.dart';

Future<Site?> showSitePicker(
  BuildContext context, {
  required List<Site> sites,
  int? selectedId,
  String title = 'Choose a site',
}) {
  return showModalBottomSheet<Site>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _SitePickerSheet(sites: sites, selectedId: selectedId, title: title),
  );
}

class _SitePickerSheet extends StatefulWidget {
  const _SitePickerSheet({required this.sites, required this.selectedId, required this.title});

  final List<Site> sites;
  final int? selectedId;
  final String title;

  @override
  State<_SitePickerSheet> createState() => _SitePickerSheetState();
}

class _SitePickerSheetState extends State<_SitePickerSheet> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final needle = _query.trim().toLowerCase();
    final filtered = widget.sites
        .where(
          (site) =>
              needle.isEmpty ||
              site.address.toLowerCase().contains(needle) ||
              site.address.toLowerCase().contains(needle) ||
              site.customer.fullName.toLowerCase().contains(needle),
        )
        .toList(growable: false);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _controller,
                    onChanged: (value) => setState(() => _query = value),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search sites or customers',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.location_off_outlined,
                      title: 'No sites found',
                      message: 'Create a site under a customer first, then attach notes to it.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, 0, AppSpacing.sm, AppSpacing.lg),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1, indent: AppSpacing.md, endIndent: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final site = filtered[index];
                        final isSelected = site.id == widget.selectedId;
                        return ListTile(
                          onTap: () => Navigator.of(context).pop(site),
                          leading: const Icon(Icons.location_on_outlined),
                          title: Text(site.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(
                            '${site.customer.fullName} · ${site.address}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle_rounded, size: 20, color: theme.colorScheme.primary)
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
