import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme_extensions.dart';
import '../../../../core/utils/widgets/app_empty_state.dart';
import '../../../../core/utils/widgets/custom_search_field.dart';
import '../../../settings/application/settings_cubit.dart';
import '../../../sites/application/site_bloc.dart';
import '../../application/note_bloc.dart';
import '../../domain/field_note.dart';
import '../../domain/note_status.dart';
import '../widgets/note_widget.dart';
import '../widgets/sync_action_button.dart';
import 'note_details_screen.dart';
import 'note_form_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String _query = '';
  NoteStatus? _status;
  int? _siteId;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
          final sites = state.items.map((e) => e.site.id).toSet().length;
          return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            const Text('Field notes'),
            Text('${state.items.length} Notes · $sites Sites', style: textTheme.labelSmall?.copyWith(fontSize: 11.5)),
          ]);
        }),
        actions: const [SyncActionButton()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'notes-add-note',
        onPressed: _addNote,
        icon: const Icon(Icons.add),
        label: const Text('New note'),
      ),
      body: Padding(
        padding: AppConstants.screenMargin(),
        child: Column(children: [
          CustomSearchField(hintText: 'Search title, description, site, customer', onChanged: (v) => setState(() => _query = v)),
          const SizedBox(height: 8),
          _filters(context),
          const SizedBox(height: 8),
          Expanded(child: BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
            if (state.loading) return const Center(child: CircularProgressIndicator());
            final notes = _filtered(state.items);
            if (notes.isEmpty) return const AppEmptyState(icon: Icons.description_outlined, title: 'No notes', message: 'Create a field note for a site.');
            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 120),
              itemCount: notes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) => NoteCard(note: notes[i], onTap: () => openNoteDetails(context, notes[i])),
            );
          })),
        ]),
      ),
    );
  }

  Widget _filters(BuildContext context) {
    final sites = context.watch<SiteBloc>().state.items;
    return Wrap(spacing: 8, runSpacing: 8, children: [
      FilterChip(label: Text(_status?.label ?? 'All statuses'), selected: _status != null, onSelected: (_) async {
        final picked = await showModalBottomSheet<NoteStatus?>(context: context, builder: (ctx) => SafeArea(child: ListView(padding: const EdgeInsets.only(top: 12), children: [
          ListTile(title: const Text('All statuses'), onTap: () => Navigator.pop(ctx, null)),
          ...NoteStatus.values.map((s) => ListTile(title: Text(s.label), onTap: () => Navigator.pop(ctx, s))),
        ])));
        if (!mounted) return;
        setState(() => _status = picked);
      }),
      FilterChip(label: Text(_siteId == null ? 'All sites' : sites.where((s)=>s.id==_siteId).map((s)=>s.name).firstOrNull ?? 'Site'), selected: _siteId != null, onSelected: (_) async {
        final picked = await showModalBottomSheet<int?>(context: context, builder: (ctx) => SafeArea(child: ListView(padding: const EdgeInsets.only(top: 12), children: [
          ListTile(title: const Text('All sites'), onTap: () => Navigator.pop(ctx, -1)),
          ...sites.map((s) => ListTile(title: Text(s.name), subtitle: Text(s.customer.fullName), onTap: () => Navigator.pop(ctx, s.id))),
        ])));
        if (!mounted) return;
        setState(() => _siteId = picked == -1 ? null : picked);
      }),
    ]);
  }

  List<FieldNote> _filtered(List<FieldNote> items) {
    final q = _query.trim().toLowerCase();
    return items.where((n) {
      if (_status != null && n.status != _status) return false;
      if (_siteId != null && n.site.id != _siteId) return false;
      if (q.isEmpty) return true;
      final hay = '${n.title} ${n.description} ${n.site.name} ${n.site.customer.fullName}'.toLowerCase();
      return hay.contains(q);
    }).toList();
  }

  Future<void> _addNote() async {
    final sites = context.read<SiteBloc>().state.items;
    final defaultStatus = context.read<SettingsCubit>().state;
    final note = await openNoteForm(
      context,
      sites: sites,
      defaultStatus: defaultStatus,
      onCaptureLocation: _captureLocation,
      onPickPhoto: _pickPhoto,
    );
    if (note == null || !mounted) return;
    context.read<NoteBloc>().add(NoteAdded(note));
  }

  Future<({double latitude, double longitude})?> _captureLocation(BuildContext context) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('Enable location services.')));
        return null;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('Location permission denied.')));
        return null;
      }
      final pos = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      return (latitude: pos.latitude, longitude: pos.longitude);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('Could not get location.')));
      return null;
    }
  }

  Future<String?> _pickPhoto(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: source, imageQuality: 85, maxWidth: 1920);
      return file?.path;
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('Could not pick photo.')));
      return null;
    }
  }
}
