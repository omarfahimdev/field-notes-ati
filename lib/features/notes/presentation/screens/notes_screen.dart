import 'package:field_notes/core/constants/app_constants.dart';
import 'package:field_notes/core/theme/app_theme_extensions.dart';
import 'package:field_notes/core/utils/widgets/custom_search_field.dart';
import 'package:field_notes/features/customers/domain/customer.dart';
import 'package:field_notes/features/notes/domain/field_note.dart';
import 'package:field_notes/features/notes/presentation/widgets/note_widget.dart';
import 'package:field_notes/features/sites/domain/site.dart';
import 'package:flutter/material.dart';

import '../widgets/sync_action_button.dart';

class NotesScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final notes = List.generate(
      10,
      (index) => FieldNote(
        id: index,
        site: Site(
          id: index,
          siteName: 'siteName',
          address: 'address',
          customer: Customer(id: index, fullName: 'fullName', phone: 'phone', email: 'email'),
        ),
        title: 'title',
        description: 'description',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Field notes'),
            const SizedBox(height: 1),
            Text(
              '3 Notes · 3 Sites',
              style: textTheme.labelSmall?.copyWith(fontSize: 11.5, letterSpacing: 0.2, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [SyncActionButton(onPressed: () {})],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: context.colorScheme.primary,
        child: Icon(Icons.add, color: context.colorScheme.onPrimary),
      ),
      body: Container(
        padding: AppConstants.screenMargin(),
        child: Column(
          children: [
            // const SyncStatusBanner(),
            CustomSearchField(),
            SizedBox(height: AppConstants.screenMarginPoint),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10),
                padding: EdgeInsets.only(bottom: 120),
                itemCount: notes.length,
                itemBuilder: (context, index) => Note(note: notes.elementAt(index)),
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
}
