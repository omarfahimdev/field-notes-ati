import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimension.dart';
import '../../../../core/utils/validators.dart';
import '../../../customers/application/customer_bloc.dart';
import '../../../customers/data/customer_repository.dart';
import '../../../customers/domain/customer.dart';
import '../../application/site_bloc.dart';
import '../../data/site_repository.dart';
import '../../domain/site.dart';

Future<Site?> openSiteForm(BuildContext context, {Site? site, List<Customer> customers = const [], Customer? initialCustomer, int? initialCustomerId}) {
  return Navigator.of(context).push<Site>(MaterialPageRoute(fullscreenDialog: true, builder: (_) => SiteFormScreen(site: site, customers: customers, initialCustomer: initialCustomer, initialCustomerId: initialCustomerId)));
}

class SiteFormScreen extends StatefulWidget {
  const SiteFormScreen({super.key, this.site, this.customers = const [], this.initialCustomer, this.initialCustomerId});
  final Site? site; final List<Customer> customers; final Customer? initialCustomer; final int? initialCustomerId;
  bool get isEditing => site != null;
  @override
  State<SiteFormScreen> createState() => _SiteFormScreenState();
}

class _SiteFormScreenState extends State<SiteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.site?.name ?? '');
  late final _address = TextEditingController(text: widget.site?.address ?? '');
  Customer? _customer;

  @override
  void initState() {
    super.initState();
    _customer = widget.site?.customer ?? widget.initialCustomer ?? widget.customers.where((c)=>c.id==widget.initialCustomerId).cast<Customer?>().firstOrNull;
  }
  @override
  void dispose() { _name.dispose(); _address.dispose(); super.dispose(); }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false) || _customer == null) return;
    final custRepo = context.read<CustomerRepository>();
    final custLocalId = custRepo.localIdForRemote(_customer!.id);
    final custRaw = custRepo.rawByLocalId(custLocalId ?? '') ?? {'id': _customer!.id, 'remoteId': _customer!.id, 'fullName': _customer!.fullName, 'phone': _customer!.phone, 'email': _customer!.email, 'address': _customer!.address};
    if (widget.site == null) {
      context.read<SiteBloc>().add(SiteAdded(name: _name.text.trim(), address: _address.text.trim(), customerRaw: Map<String,dynamic>.from(custRaw)));
    } else {
      final localId = context.read<SiteRepository>().localIdForRemote(widget.site!.id);
      if (localId != null) context.read<SiteBloc>().add(SiteUpdated(localId: localId, name: _name.text.trim(), address: _address.text.trim(), customerRaw: Map<String,dynamic>.from(custRaw)));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final customers = widget.customers.isNotEmpty ? widget.customers : context.watch<CustomerBloc>().state.items;
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit site' : 'New site')),
      body: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        DropdownButtonFormField<int>(
          initialValue: _customer?.id,
          items: customers.map((c)=>DropdownMenuItem(value: c.id, child: Text(c.fullName))).toList(),
          onChanged: (id) => setState(()=>_customer = customers.where((c)=>c.id==id).cast<Customer?>().firstOrNull),
          decoration: const InputDecoration(labelText: 'Customer'),
          validator: (_) => _customer == null ? 'Select a customer' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Site name'), validator: (v)=>Validators.minLength(v,2,label:'Site name')),
        const SizedBox(height: 12),
        TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Address'), validator: (v)=>Validators.minLength(v,4,label:'Address'), maxLines: 2),
      ])),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: FilledButton.icon(onPressed: _save, icon: const Icon(Icons.check_rounded), label: Text(widget.isEditing ? 'Save changes' : 'Add site')))),
    );
  }
}
