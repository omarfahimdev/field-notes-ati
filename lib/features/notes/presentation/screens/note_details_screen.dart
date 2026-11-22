import 'package:field_notes/features/customers/domain/customer.dart';
import 'package:field_notes/features/notes/domain/field_note.dart';
import 'package:field_notes/features/notes/domain/note_status.dart';
import 'package:field_notes/features/notes/presentation/screens/note_form_screen.dart';
import 'package:field_notes/features/sites/domain/site.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

Future<void> openNoteDetails(BuildContext context, int noteId) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteDetailsScreen(noteId: noteId)));
}

class NoteDetailsScreen extends StatefulWidget {
  final int noteId;

  const NoteDetailsScreen({super.key, required this.noteId});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final note = FieldNote(
      id: 1,
      site: Site(
        id: 1,
        name: 'siteName',
        address: 'address',
        customer: Customer(id: 1, fullName: 'fullName', phone: 'phone', email: 'email'),
      ),
      title: 'title',
      description: 'description',
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Field note'),
        actions: [
          IconButton(tooltip: 'Edit note', onPressed: () => _onEdit(note), icon: const Icon(Iconsax.edit)),
          IconButton(
            tooltip: 'Delete note',
            onPressed: () => _onDelete(note),
            icon: Icon(Iconsax.trash, color: colorScheme.error),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.hasPhoto) ...[_PhotoBanner(photoUrl: note.photoUrl!), const SizedBox(height: 16)],

            // Status + Site + Customer summary
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _StatusChip(status: note.status),
                Chip(avatar: const Icon(Iconsax.building_4, size: 16), label: Text(note.site.name)),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            Text(note.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),

            // Address & Timestamp
            Row(
              children: [
                Icon(Iconsax.location, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    note.site.address,
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Iconsax.calendar_1, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  _formatDateTime(note.occurredAt),
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description
            Text('Description', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Text(
                note.description.isNotEmpty ? note.description : 'No description provided.',
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
            ),
            const SizedBox(height: 20),

            // Site & Customer info
            Text('Site & Customer', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _SiteCustomerCard(site: note.site),

            // Location (shown only when note.hasLocation is true)
            if (note.hasLocation) ...[
              const SizedBox(height: 20),
              Text('GPS Location', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _LocationCard(note: note),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Not recorded';
    final local = dateTime.toLocal();
    final date = '${local.year}-${_twoDigits(local.month)}-${_twoDigits(local.day)}';
    final time = '${_twoDigits(local.hour)}:${_twoDigits(local.minute)}';
    return '$date • $time';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  void _onEdit(FieldNote note) => openNoteForm(context, initialNote: note);

  Future<void> _onDelete(FieldNote note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete field note?'),
        content: Text('Delete "${note.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).pop(note.id);
    }
  }
}

class _SiteCustomerCard extends StatelessWidget {
  final Site site;

  const _SiteCustomerCard({required this.site});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customer = site.customer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(icon: Iconsax.building_4, label: 'Site', value: site.name),
          const SizedBox(height: 8),
          _InfoRow(icon: Iconsax.map_1, label: 'Address', value: site.address),
          const Divider(height: 20),
          _InfoRow(icon: Iconsax.user, label: 'Customer', value: customer.fullName),
          const SizedBox(height: 8),
          _InfoRow(icon: Iconsax.call, label: 'Phone', value: customer.phone),
          const SizedBox(height: 8),
          _InfoRow(icon: Iconsax.sms, label: 'Email', value: customer.email),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 10),
        SizedBox(
          width: 76,
          child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
        ),
        Expanded(
          child: Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

class _PhotoBanner extends StatelessWidget {
  final String photoUrl;

  const _PhotoBanner({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          photoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, _, _) => Container(
            color: colorScheme.surfaceContainerHighest,
            alignment: Alignment.center,
            child: const Icon(Iconsax.gallery_slash),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final NoteStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = status.name.isEmpty ? status.name : status.name[0].toUpperCase() + status.name.substring(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final FieldNote note;

  const _LocationCard({required this.note});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Iconsax.gps, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(note.location.toString())),
        ],
      ),
    );
  }
}
