import 'package:field_notes/core/theme/app_theme_extensions.dart';
import 'package:field_notes/features/customers/domain/customer.dart';
import 'package:field_notes/features/customers/presentation/screens/customer_details.dart';
import 'package:field_notes/features/customers/presentation/screens/customer_form_screen.dart';
import 'package:field_notes/features/customers/presentation/widgets/customer_card.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/widgets/custom_search_field.dart';
import '../../../notes/presentation/widgets/sync_action_button.dart';
import '../../../sites/presentation/screens/site_form_screen.dart';

class CustomersScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final customer = Customer(
      id: 1,
      fullName: 'Fazle Elahi Fahim',
      phone: '01839865200',
      email: 'omar@gmail.com',
      address: '',
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Customers'),
            const SizedBox(height: 1),
            Text(
              '2 Customers · 3 Sites',
              style: textTheme.labelSmall?.copyWith(
                fontSize: 11.5,
                letterSpacing: 0.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'New site',
            onPressed: () => _onAddSite(customer),
            icon: const Icon(Icons.add_location_alt_outlined),
          ),
          SyncActionButton(onPressed: () {}),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        // AppShell keeps this screen mounted next to NotesScreen in an
        // IndexedStack, so the FAB tag must be unique within the shared route.
        heroTag: 'customers-add-customer',
        onPressed: _onAdd,
        backgroundColor: colorScheme.primary,
        icon: Icon(Icons.add, color: colorScheme.onPrimary),
        label: Text('New customer'),
      ),
      body: Container(
        padding: AppConstants.screenMargin(),
        child: Column(
          children: [
            CustomSearchField(onChanged: (value) {}),
            SizedBox(height: AppConstants.screenMarginPoint),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10),
                padding: EdgeInsets.only(bottom: 120),
                itemCount: 5,
                itemBuilder: (context, index) =>
                    CustomerCard(customer: customer, onTap: _onTap),

                // Note(note: notes.elementAt(index), onTap: () => openNoteDetails(context, index)),
              ),
            ),
            // const SizedBox(height: AppSpacing.md),
            // _FilterBar(state: state),
            // const SizedBox(height: AppSpacing.sm),
            // Expanded(child: _NotesList(state: state)),
          ],
        ),
      ),
    );
  }

  void _onAdd() => openCustomerForm(context);

  Future<void> _onAddSite(Customer customer) async {
    await openSiteForm(
      context,
      customers: [customer],
      initialCustomer: customer,
    );
  }

  void _onTap() => openCustomerDetail(
    context,
    Customer(
      id: 1,
      fullName: 'Fazle Elahi Fahim',
      phone: '01839865200',
      email: 'omar@gmail.com',
      address: '',
    ),
  );
}
