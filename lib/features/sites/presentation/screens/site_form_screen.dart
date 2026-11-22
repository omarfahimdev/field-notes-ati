import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimension.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/widgets/custom_inkwell_button.dart';
import '../../../customers/domain/customer.dart';
import '../../domain/site.dart';

Future<Site?> openSiteForm(
  BuildContext context, {
  Site? site,
  List<Customer> customers = const [],
  Customer? initialCustomer,
  int? initialCustomerId,
}) {
  return Navigator.of(context).push<Site>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => SiteFormScreen(
        site: site,
        customers: customers,
        initialCustomer: initialCustomer,
        initialCustomerId: initialCustomerId,
      ),
    ),
  );
}

class SiteFormScreen extends StatefulWidget {
  const SiteFormScreen({super.key, this.site, this.customers = const [], this.initialCustomer, this.initialCustomerId});

  final Site? site;
  final List<Customer> customers;
  final Customer? initialCustomer;
  final int? initialCustomerId;

  bool get isEditing => site != null;

  @override
  State<SiteFormScreen> createState() => _SiteFormScreenState();
}

class _SiteFormScreenState extends State<SiteFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();

  late List<Customer> _customers;
  Customer? _selectedCustomer;
  bool _customerError = false;

  @override
  void initState() {
    super.initState();
    _customers = List<Customer>.from(widget.customers);

    final site = widget.site;
    if (site != null) {
      _name.text = site.name;
      _address.text = site.address;
      _selectedCustomer = _findCustomer(site.customer.id) ?? site.customer;
      return;
    }

    final initialCustomer = widget.initialCustomer;
    if (initialCustomer != null) {
      _selectedCustomer = _findCustomer(initialCustomer.id) ?? initialCustomer;
      return;
    }

    final initialCustomerId = widget.initialCustomerId;
    if (initialCustomerId != null) {
      _selectedCustomer = _findCustomer(initialCustomerId);
    }
  }

  @override
  void didUpdateWidget(covariant SiteFormScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.customers != oldWidget.customers) {
      _customers = List<Customer>.from(widget.customers);
      final current = _selectedCustomer;
      if (current != null) {
        _selectedCustomer = _findCustomer(current.id) ?? current;
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  Customer? _findCustomer(int id) {
    for (final customer in _customers) {
      if (customer.id == id) return customer;
    }
    return null;
  }

  void _showMessage(String message) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickCustomer() async {
    if (_customers.isEmpty) {
      _showMessage('Add a customer before creating a site.');
      return;
    }

    final selection = await showModalBottomSheet<Customer>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.sm),
                child: Text('Choose a customer', style: theme.textTheme.titleLarge),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.sm, 0, AppSpacing.sm, AppSpacing.lg),
                  itemCount: _customers.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, indent: AppSpacing.md, endIndent: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final customer = _customers[index];
                    final isSelected = customer.id == _selectedCustomer?.id;
                    return ListTile(
                      leading: const Icon(Icons.business_outlined),
                      title: Text(customer.fullName),
                      subtitle: Text(customer.email),
                      trailing: isSelected
                          ? Icon(Icons.check_circle_rounded, size: 20, color: theme.colorScheme.primary)
                          : null,
                      onTap: () => Navigator.of(sheetContext).pop(customer),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selection == null || !mounted) return;
    setState(() {
      _selectedCustomer = selection;
      _customerError = false;
    });
  }

  void _save() {
    final isValid = _formKey.currentState?.validate() ?? false;
    final customer = _selectedCustomer;
    if (customer == null) {
      setState(() => _customerError = true);
      return;
    }
    if (!isValid) return;

    FocusScope.of(context).unfocus();
    Navigator.of(
      context,
    ).pop(Site(id: widget.site?.id ?? 0, name: _name.text.trim(), address: _address.text.trim(), customer: customer));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selectedCustomer = _selectedCustomer;

    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit site' : 'New site')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
          children: [
            Text(
              'A site always belongs to one customer. Notes are attached to the site, so the customer details are never duplicated.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            MyInkWellButton(
              onTap: _pickCustomer,
              backgroundColor: scheme.surfaceContainerLowest,
              decoration: BoxDecoration(
                border: Border.all(color: scheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(AppSpacing.md + 2),
              child: Row(
                children: [
                  Icon(Icons.business_outlined, size: 18, color: scheme.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer', style: theme.textTheme.labelSmall),
                        const SizedBox(height: 2),
                        Text(
                          selectedCustomer?.fullName ?? 'Choose a customer',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: selectedCustomer == null ? scheme.onSurfaceVariant : scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 18, color: scheme.onSurfaceVariant),
                ],
              ),
            ),
            if (_customerError)
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.xs, top: AppSpacing.sm - 2),
                child: Text(
                  'Choose the customer this site belongs to.',
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.error),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: (value) => Validators.minLength(value, 2, label: 'Site name'),
              decoration: const InputDecoration(
                labelText: 'Site name',
                hintText: 'e.g. Depot — Bay 4',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _address,
              maxLines: 3,
              minLines: 2,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) => Validators.minLength(value, 4, label: 'Address'),
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Street, city, access notes',
                prefixIcon: Icon(Icons.map_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border(top: BorderSide(color: scheme.outlineVariant)),
          ),
          child: FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check_rounded, size: 18),
            label: Text(widget.isEditing ? 'Save changes' : 'Add site'),
          ),
        ),
      ),
    );
  }
}
