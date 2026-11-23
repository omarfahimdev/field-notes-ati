import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimension.dart';
import '../../../notes/application/note_bloc.dart';
import '../../../sites/application/site_bloc.dart';
import '../../../sites/presentation/screens/site_form_screen.dart';
import '../../application/customer_bloc.dart';
import '../../data/customer_repository.dart';
import '../../domain/customer.dart';
import 'customer_form_screen.dart';

Future<void> openCustomerDetail(BuildContext context, Customer customer) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (_) => CustomerDetailScreen(customerId: customer.id)));
}

class CustomerDetailScreen extends StatelessWidget {
  final int customerId;
  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    final customers = context.watch<CustomerBloc>().state.items;
    final customer = customers.where((c)=>c.id==customerId).cast<Customer?>().firstOrNull;
    if (customer == null) return Scaffold(appBar: AppBar(), body: const Center(child: Text('Customer not found')));
    final sites = context.watch<SiteBloc>().state.items.where((s)=>s.customer.id==customer.id).toList();
    final notes = context.watch<NoteBloc>().state.items.where((n)=>n.site.customer.id==customer.id).toList();
    final theme = Theme.of(context); final scheme = theme.colorScheme;
    final repo = context.read<CustomerRepository>();
    final localId = repo.localIdForRemote(customer.id);
    return Scaffold(
      appBar: AppBar(title: Text(customer.fullName), actions: [
        IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => openCustomerForm(context, customer: customer)),
        IconButton(icon: Icon(Icons.delete_outline_rounded, color: scheme.error), onPressed: () async {
          final ok = await showDialog<bool>(context: context, builder: (d)=>AlertDialog(title: const Text('Delete customer?'), content: const Text('This also removes related sites and notes locally.'), actions:[TextButton(onPressed:()=>Navigator.pop(d,false), child: const Text('Cancel')), FilledButton(onPressed:()=>Navigator.pop(d,true), child: const Text('Delete'))]));
          if (ok==true && localId!=null && context.mounted) { context.read<CustomerBloc>().add(CustomerDeleted(localId)); Navigator.of(context).pop(); }
        }),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => openSiteForm(context, customers: context.read<CustomerBloc>().state.items, initialCustomer: customer), icon: const Icon(Icons.add_location_alt_outlined), label: const Text('Add site')),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
        Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(customer.fullName, style: theme.textTheme.titleLarge),
          if (customer.email.isNotEmpty) Text(customer.email),
          if (customer.phone.isNotEmpty) Text(customer.phone),
          if ((customer.address ?? '').isNotEmpty) Text(customer.address!),
          const SizedBox(height: 8),
          Text('${sites.length} sites · ${notes.length} notes', style: theme.textTheme.bodySmall),
        ]))),
        const SizedBox(height: 16),
        Text('Sites', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (sites.isEmpty) const Text('No sites yet') else ...sites.map((s) => Card(child: ListTile(title: Text(s.name), subtitle: Text(s.address), trailing: IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => openSiteForm(context, site: s, customers: context.read<CustomerBloc>().state.items))))),
      ]),
    );
  }
}
