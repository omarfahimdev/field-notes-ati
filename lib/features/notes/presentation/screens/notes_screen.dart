import 'package:field_notes/core/constants/app_constants.dart';
import 'package:field_notes/core/theme/app_theme_extensions.dart';
import 'package:field_notes/core/utils/widgets/custom_search_field.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Text('Field notes'),
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
