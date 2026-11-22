import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_dimension.dart';
import '../../../sites/domain/site.dart';
import '../../../sites/presentation/screens/site_form_screen.dart';
import '../../domain/customer.dart';
import 'customer_form_screen.dart';

Future<void> openCustomerDetail(
  BuildContext context,
  Customer customer, {
  List<Site> sites = const [],
  int noteCount = 0,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => CustomerDetailScreen(
        customer: customer,
        sites: sites,
        noteCount: noteCount,
      ),
    ),
  );
}

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({
    super.key,
    required this.customer,
    this.sites = const [],
    this.noteCount = 0,
  });

  final Customer customer;
  final List<Site> sites;
  final int noteCount;

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late List<Site> _sites;

  @override
  void initState() {
    super.initState();
    _sites = List<Site>.from(widget.sites);
  }

  @override
  void didUpdateWidget(covariant CustomerDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sites != oldWidget.sites) {
      _sites = List<Site>.from(widget.sites);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final customer = widget.customer;
    final hasContactDetails =
        customer.email.isNotEmpty ||
        customer.phone.isNotEmpty ||
        (customer.address ?? '').isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          customer.fullName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: 'Edit customer',
            onPressed: () => openCustomerForm(context, customer: customer),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Delete customer',
            onPressed: _confirmDelete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xs,
          AppSpacing.lg,
          AppSpacing.huge,
        ),
        children: [
          Card(
            margin: EdgeInsets.zero,
            color: scheme.surfaceContainerLow,
            surfaceTintColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          _initials(customer.fullName),
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md + 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              customer.phone.isEmpty
                                  ? 'No contact number yet'
                                  : customer.phone,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (hasContactDetails) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Divider(height: 1),
                    ),
                    if (customer.email.isNotEmpty)
                      _contactRow(
                        context,
                        Icons.alternate_email_rounded,
                        customer.email,
                      ),
                    if (customer.phone.isNotEmpty)
                      _contactRow(
                        context,
                        Icons.phone_outlined,
                        customer.phone,
                      ),
                    if ((customer.address ?? '').isNotEmpty)
                      _contactRow(
                        context,
                        Icons.map_outlined,
                        customer.address ?? '',
                      ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _statPill(
                        context,
                        '${_sites.length}',
                        'Sites',
                        Icons.location_on_outlined,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _statPill(
                        context,
                        '${widget.noteCount}',
                        'Notes',
                        Icons.description_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Text(
                'SITES',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _addSite,
                icon: const Icon(Icons.add_rounded, size: 17),
                label: const Text('Add site'),
              ),
            ],
          ),
          if (_sites.isEmpty)
            Card(
              margin: EdgeInsets.zero,
              color: scheme.surfaceContainerLow,
              surfaceTintColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_location_alt_outlined,
                      size: 26,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text('No sites yet', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      'Create the first site for this customer to start collecting field notes.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton(
                      onPressed: _addSite,
                      child: const Text('Add a site'),
                    ),
                  ],
                ),
              ),
            )
          else
            for (final site in _sites)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
                child: Card(
                  margin: EdgeInsets.zero,
                  color: scheme.surfaceContainerLow,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(
                      site.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      site.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: scheme.onSurfaceVariant,
                    ),
                    onTap: () => _editSite(site),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Future<void> _addSite() async {
    final created = await openSiteForm(
      context,
      customers: [widget.customer],
      initialCustomer: widget.customer,
    );
    if (created == null || !mounted) return;

    var nextId = 1;
    for (final site in _sites) {
      if (site.id >= nextId) nextId = site.id + 1;
    }
    setState(() {
      _sites = [
        ..._sites,
        Site(
          id: nextId,
          name: created.name,
          address: created.address,
          customer: created.customer,
        ),
      ];
    });
  }

  Future<void> _editSite(Site site) async {
    final updated = await openSiteForm(
      context,
      site: site,
      customers: [widget.customer],
    );
    if (updated == null || !mounted) return;
    setState(() {
      _sites = _sites
          .map((item) => item.id == site.id ? updated : item)
          .toList();
    });
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  Widget _contactRow(BuildContext context, IconData icon, String value) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 16, color: scheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13.5),
            ),
          ),
          InkWell(
            onTap: () => Clipboard.setData(ClipboardData(text: value)),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.copy_all_outlined,
                size: 16,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statPill(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm - 2,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(fontSize: 13),
          ),
          const SizedBox(width: 4),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete ${widget.customer.fullName}?'),
        content: Text(
          'This removes ${_sites.length} ${_sites.length == 1 ? 'site' : 'sites'} and ${widget.noteCount} '
          '${widget.noteCount == 1 ? 'field note' : 'field notes'} belonging to this customer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
              foregroundColor: Theme.of(dialogContext).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete everything'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    Navigator.of(context).pop();
  }
}
