import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/widgets/app_empty_state.dart';
import '../../../../core/utils/widgets/custom_search_field.dart';
import '../../../notes/application/note_bloc.dart';
import '../../../sites/application/site_bloc.dart';
import '../../application/customer_bloc.dart';
import '../widgets/customer_card.dart';
import 'customer_details.dart';
import 'customer_form_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});
  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String _q = '';
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CustomerBloc, CustomerState>(builder: (context, s) => Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          const Text('Customers'),
          Text('${s.items.length} Customers', style: textTheme.labelSmall?.copyWith(fontSize: 11.5)),
        ])),
      ),
      floatingActionButton: FloatingActionButton.extended(heroTag: 'customers-add-customer', onPressed: () => openCustomerForm(context), icon: const Icon(Icons.add), label: const Text('New customer')),
      body: Padding(
        padding: AppConstants.screenMargin(),
        child: Column(children: [
          CustomSearchField(hintText: 'Search customers', onChanged: (v)=>setState(()=>_q=v)),
          const SizedBox(height: 10),
          Expanded(child: BlocBuilder<CustomerBloc, CustomerState>(builder: (context, state) {
            if (state.loading) return const Center(child: CircularProgressIndicator());
            final q = _q.trim().toLowerCase();
            final items = state.items.where((c) => q.isEmpty || '${c.fullName} ${c.email} ${c.phone}'.toLowerCase().contains(q)).toList();
            if (items.isEmpty) return const AppEmptyState(icon: Icons.people_outline_rounded, title: 'No customers', message: 'Add a customer to get started.');
            final sites = context.watch<SiteBloc>().state.items;
            final notes = context.watch<NoteBloc>().state.items;
            return ListView.separated(padding: const EdgeInsets.only(bottom: 120), itemCount: items.length, separatorBuilder: (_, _)=>const SizedBox(height:10), itemBuilder: (context,i){
              final c = items[i];
              final siteCount = sites.where((s)=>s.customer.id==c.id).length;
              final noteCount = notes.where((n)=>n.site.customer.id==c.id).length;
              return CustomerCard(customer: c, siteCount: siteCount, noteCount: noteCount, onTap: () => openCustomerDetail(context, c));
            });
          })),
        ]),
      ),
    );
  }
}
