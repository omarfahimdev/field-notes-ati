import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimension.dart';
import '../../../notes/data/note_repository.dart';
import '../../../sites/application/site_bloc.dart';
import '../../application/note_bloc.dart';
import '../../domain/field_note.dart';
import '../widgets/status_chip.dart';
import 'note_form_screen.dart';

Future<void> openNoteDetails(BuildContext context, FieldNote note) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteDetailsScreen(noteId: note.id)));
}

class NoteDetailsScreen extends StatelessWidget {
  final int noteId;
  const NoteDetailsScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
      final note = state.items.where((n) => n.id == noteId).cast<FieldNote?>().firstOrNull;
      if (note == null) return Scaffold(appBar: AppBar(), body: const Center(child: Text('Note not found')));
      final theme = Theme.of(context); final scheme = theme.colorScheme;
      return Scaffold(
        appBar: AppBar(title: const Text('Field note'), actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _edit(context, note)),
          IconButton(icon: Icon(Icons.delete_outline_rounded, color: scheme.error), onPressed: () => _delete(context, note)),
        ]),
        body: ListView(padding: const EdgeInsets.all(AppSpacing.lg), children: [
          if (note.hasPhoto) ...[ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(note.photoUrl!, height: 220, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, _, _)=>Container(height:220,color:scheme.surfaceContainerHighest,child:const Icon(Icons.broken_image_outlined)))), const SizedBox(height: 16)],
          Wrap(spacing: 8, runSpacing: 8, children: [StatusChip(status: note.status), Chip(label: Text(note.site.name)), Chip(label: Text(note.site.customer.fullName))]),
          const SizedBox(height: 12),
          Text(note.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(note.description.isEmpty ? 'No description' : note.description, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 16),
          _row(theme, 'Occurred', _fmt(note.occurredAt)),
          _row(theme, 'Site', '${note.site.name}\n${note.site.address}'),
          _row(theme, 'Customer', '${note.site.customer.fullName}\n${note.site.customer.email}\n${note.site.customer.phone}'),
          if (note.hasLocation) _row(theme, 'Location', note.location!.locationSummary),
        ]),
      );
    });
  }

  Widget _row(ThemeData theme, String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(label, style: theme.textTheme.labelSmall), const SizedBox(height:2), Text(value)]));

  String _fmt(DateTime? dt) { if (dt==null) return 'Not recorded'; final l=dt.toLocal(); return '${l.year}-${l.month.toString().padLeft(2,'0')}-${l.day.toString().padLeft(2,'0')} ${l.hour.toString().padLeft(2,'0')}:${l.minute.toString().padLeft(2,'0')}'; }

  Future<void> _edit(BuildContext context, FieldNote note) async {
    final sites = context.read<SiteBloc>().state.items;
    final updated = await openNoteForm(context, note: note, sites: sites);
    if (updated == null || !context.mounted) return;
    final localId = context.read<NoteRepository>().localIdForRemote(note.id);
    if (localId == null) return;
    context.read<NoteBloc>().add(NoteUpdated(localId, updated));
  }

  Future<void> _delete(BuildContext context, FieldNote note) async {
    final ok = await showDialog<bool>(context: context, builder: (d)=>AlertDialog(title: const Text('Delete note?'), content: Text('Delete "${note.title}"?'), actions:[TextButton(onPressed:()=>Navigator.pop(d,false), child: const Text('Cancel')), FilledButton(onPressed:()=>Navigator.pop(d,true), child: const Text('Delete'))]));
    if (ok != true || !context.mounted) return;
    final localId = context.read<NoteRepository>().localIdForRemote(note.id);
    if (localId != null) context.read<NoteBloc>().add(NoteDeleted(localId));
    Navigator.of(context).pop();
  }
}
