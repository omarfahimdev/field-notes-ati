import 'package:field_notes/core/utils/extensions/button_style_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimension.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/customer.dart';

Future<bool?> openCustomerForm(BuildContext context, {Customer? customer}) {
  return Navigator.of(context)
      .push<bool>(MaterialPageRoute(fullscreenDialog: true, builder: (_) => CustomerFormScreen(customer: customer)));
}

class CustomerFormScreen extends StatefulWidget {
  const CustomerFormScreen({super.key, this.customer});

  final Customer? customer;

  bool get isEditing => customer != null;

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _contactName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  final bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final customer = widget.customer;
    _name = TextEditingController(text: customer?.fullName ?? '');
    _contactName = TextEditingController(text: customer?.phone ?? '');
    _email = TextEditingController(text: customer?.email ?? '');
    _phone = TextEditingController(text: customer?.phone ?? '');
    _address = TextEditingController(text: customer?.address ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _contactName.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // if (!(_formKey.currentState?.validate() ?? false)) return;
    // FocusScope.of(context).unfocus();
    // setState(() => _isSaving = true);

    // final repository = context.read<CustomerRepository>();
    // final navigator = Navigator.of(context);
    // final messenger = ScaffoldMessenger.of(context);

    // try {
    //   final customer = widget.customer;
    //   if (customer == null) {
    //     await repository.create(
    //       name: _name.text,
    //       contactName: _contactName.text,
    //       email: _email.text,
    //       phone: _phone.text,
    //       address: _address.text,
    //     );
    //   } else {
    //     await repository.update(
    //       customer,
    //       name: _name.text,
    //       contactName: _contactName.text,
    //       email: _email.text,
    //       phone: _phone.text,
    //       address: _address.text,
    //     );
    //   }
    //   navigator.pop(true);
    //   messenger
    //     ..hideCurrentSnackBar()
    //     ..showSnackBar(
    //       SnackBar(
    //         content: Text(
    //           widget.isEditing
    //               ? 'Customer updated.'
    //               : 'Customer added on this device.',
    //         ),
    //       ),
    //     );
    // } on AppException catch (error) {
    //   if (!mounted) return;
    //   setState(() => _isSaving = false);
    //   showAppSnack(context, error.message, isError: true);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit customer' : 'New customer')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
          children: [
            Text(
              'Contact details are optional, but they make it easy to reach the site contact from the field.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Customer name',
                hintText: 'e.g. North Gate Logistics',
                prefixIcon: Icon(Icons.business_outlined),
              ),
              validator: (value) => Validators.minLength(value, 2, label: 'Customer name'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _contactName,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Contact person',
                hintText: 'e.g. Omar Fahim',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'name@company.com',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
              validator: (value) {
                if ((value ?? '').trim().isEmpty) return null;
                return Validators.email(value);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: '+1 415 555 0134',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _address,
              maxLines: 3,
              minLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Billing address (optional)',
                hintText: 'Street, city, postcode',
                prefixIcon: Icon(Icons.map_outlined),
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
            color: theme.colorScheme.surface,
            border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
          ),
          child: FilledButton.icon(
            label: Text(widget.isEditing ? 'Save changes' : 'Add customer'),
            icon: Icon(Icons.check_rounded),
            onPressed: _save,
          ).withLoading(_isSaving),
        ),
      ),
    );
  }
}
