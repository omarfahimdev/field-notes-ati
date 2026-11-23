import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimension.dart';
import '../../../../core/utils/extensions/button_style_extension.dart';
import '../../../../core/utils/validators.dart';
import '../../application/customer_bloc.dart';
import '../../data/customer_repository.dart';
import '../../domain/customer.dart';

Future<void> openCustomerForm(BuildContext context, {Customer? customer}) {
  return Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: (_) => CustomerFormScreen(customer: customer)));
}

class CustomerFormScreen extends StatefulWidget {
  const CustomerFormScreen({super.key, this.customer});
  final Customer? customer;
  bool get isEditing => customer != null;
  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.customer?.fullName ?? '');
  late final _email = TextEditingController(text: widget.customer?.email ?? '');
  late final _phone = TextEditingController(text: widget.customer?.phone ?? '');
  late final _address = TextEditingController(text: widget.customer?.address ?? '');
  bool _saving = false;

  @override
  void dispose() { _name.dispose(); _email.dispose(); _phone.dispose(); _address.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final bloc = context.read<CustomerBloc>();
    if (widget.customer == null) {
      bloc.add(CustomerAdded(fullName: _name.text.trim(), phone: _phone.text.trim(), email: _email.text.trim(), address: _address.text.trim()));
    } else {
      final localId = context.read<CustomerRepository>().localIdForRemote(widget.customer!.id);
      if (localId != null) {
        bloc.add(CustomerUpdated(localId: localId, fullName: _name.text.trim(), phone: _phone.text.trim(), email: _email.text.trim(), address: _address.text.trim()));
      }
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit customer' : 'New customer')),
      body: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Customer name', prefixIcon: Icon(Icons.business_outlined)), validator: (v)=>Validators.minLength(v,2,label:'Customer name')),
        const SizedBox(height: 12),
        TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.alternate_email_rounded)), validator: Validators.email),
        const SizedBox(height: 12),
        TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone_outlined)), validator: (v)=>Validators.minLength(v,3,label:'Phone')),
        const SizedBox(height: 12),
        TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Address (optional)', prefixIcon: Icon(Icons.map_outlined)), maxLines: 2),
      ])),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: FilledButton.icon(onPressed: _saving?null:_save, icon: const Icon(Icons.check_rounded), label: Text(widget.isEditing?'Save changes':'Add customer')).withLoading(_saving))),
    );
  }
}
