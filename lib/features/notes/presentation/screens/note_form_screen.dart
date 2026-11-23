import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_dimension.dart';
import '../../../sites/domain/site.dart';
import '../../../sites/presentation/widgets/site_picker_sheet.dart';
import '../../domain/field_note.dart';
import '../../domain/location.dart';
import '../../domain/note_status.dart';
import '../widgets/status_chip.dart';
import '../widgets/status_picker_sheet.dart';

/// Callback contract for handling form submission without BLoC.
typedef NoteFormSubmitCallback = FutureOr<void> Function(FieldNote draftNote);

/// Optional service/callback hooks so you can plug in your own location,
/// photo picking/deletion, and available sites without BLoC.
typedef LocationCaptureCallback =
    Future<({double latitude, double longitude})?> Function(
      BuildContext context,
    );
typedef PhotoPickCallback = Future<String?> Function(
  BuildContext context,
  ImageSource source,
);
typedef PhotoDeleteCallback = Future<void> Function(String path);

Future<FieldNote?> openNoteForm(
  BuildContext context, {
  FieldNote? note,
  FieldNote? initialNote,
  int? initialSiteId,
  List<Site> sites = const [],
  NoteStatus defaultStatus = NoteStatus.draft,
  NoteFormSubmitCallback? onSubmit,
  LocationCaptureCallback? onCaptureLocation,
  PhotoPickCallback? onPickPhoto,
  PhotoDeleteCallback? onDeletePhoto,
}) {
  return Navigator.of(context).push<FieldNote>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => NoteFormScreen(
        note: note,
        initialNote: initialNote,
        initialSiteId: initialSiteId,
        sites: sites,
        defaultStatus: defaultStatus,
        onSubmit: onSubmit,
        onCaptureLocation: onCaptureLocation,
        onPickPhoto: onPickPhoto,
        onDeletePhoto: onDeletePhoto,
      ),
    ),
  );
}

class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({
    super.key,
    this.note,
    this.initialNote,
    this.initialSiteId,
    this.sites = const [],
    this.defaultStatus = NoteStatus.draft,
    this.onSubmit,
    this.onCaptureLocation,
    this.onPickPhoto,
    this.onDeletePhoto,
  });

  final FieldNote? note;

  /// Alias used by the note details screen when opening the editor.
  final FieldNote? initialNote;
  final int? initialSiteId;
  final List<Site> sites;
  final NoteStatus defaultStatus;
  final NoteFormSubmitCallback? onSubmit;
  final LocationCaptureCallback? onCaptureLocation;
  final PhotoPickCallback? onPickPhoto;
  final PhotoDeleteCallback? onDeletePhoto;

  FieldNote? get editingNote => note ?? initialNote;

  bool get isEditing => editingNote != null;

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late List<Site> _sites;
  Site? _selectedSite;
  late DateTime _occurredAt;
  late NoteStatus _status;
  double? _latitude;
  double? _longitude;
  String? _locationLabel;
  String? _photoUrl;

  bool _isSaving = false;
  bool _isLocating = false;
  bool _siteError = false;

  @override
  void initState() {
    super.initState();
    _sites = List<Site>.from(widget.sites);

    final existing = widget.editingNote;
    if (existing != null) {
      _titleController.text = existing.title;
      _descriptionController.text = existing.description;
      _occurredAt = existing.occurredAt ?? DateTime.now();
      _status = existing.status;
      _latitude = existing.location?.latitude;
      _longitude = existing.location?.longitude;
      _locationLabel = existing.location?.label;
      _photoUrl = existing.photoUrl;
      _selectedSite = _findSiteById(existing.site.id) ?? existing.site;
    } else {
      _occurredAt = DateTime.now();
      _status = widget.defaultStatus;
      final initialSiteId = widget.initialSiteId;
      if (initialSiteId != null) {
        _selectedSite = _findSiteById(initialSiteId);
      }
    }
  }

  @override
  void didUpdateWidget(covariant NoteFormScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sites != oldWidget.sites) {
      _sites = List<Site>.from(widget.sites);
      final current = _selectedSite;
      if (current != null) {
        _selectedSite = _findSiteById(current.id) ?? current;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Site? _findSiteById(int id) {
    for (final site in _sites) {
      if (site.id == id) return site;
    }
    return null;
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    final scheme = Theme.of(context).colorScheme;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: isError ? scheme.onError : scheme.onSurface),
        ),
        backgroundColor: isError ? scheme.error : scheme.surfaceContainerHigh,
      ),
    );
  }

  Future<void> _pickSite() async {
    final selection = await showSitePicker(
      context,
      sites: _sites,
      selectedId: _selectedSite?.id,
    );
    if (selection == null || !mounted) return;
    setState(() {
      _selectedSite = selection;
      _siteError = false;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(
        now.year,
        now.month,
        now.day,
      ).add(const Duration(days: 365)),
      helpText: 'Visit date',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _occurredAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _occurredAt.hour,
        _occurredAt.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_occurredAt),
      helpText: 'Visit time',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _occurredAt = DateTime(
        _occurredAt.year,
        _occurredAt.month,
        _occurredAt.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  Future<void> _pickStatus() async {
    final selected = await showStatusPicker(context, selected: _status);
    if (selected == null || !mounted) return;
    setState(() => _status = selected);
  }

  Future<void> _captureLocation() async {
    final capture = widget.onCaptureLocation;
    if (capture == null) {
      _showMessage('Location capture handler is not connected.', isError: true);
      return;
    }

    setState(() => _isLocating = true);
    try {
      final coords = await capture(context);
      if (!mounted) return;
      if (coords != null) {
        setState(() {
          _latitude = coords.latitude;
          _longitude = coords.longitude;
        });
        _showMessage('Location attached to this note.');
      }
    } catch (_) {
      if (!mounted) return;
      _showMessage('Location is not available right now.', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLocating = false);
      }
    }
  }

  void _clearLocation() => setState(() {
    _latitude = null;
    _longitude = null;
    _locationLabel = null;
  });

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      useSafeArea: true,
      builder: (sheetContext) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            0,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add a photo',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Photos are stored with the note on this device.',
                style: Theme.of(sheetContext).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take a photo'),
                subtitle: const Text('Uses the camera'),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                subtitle: const Text('Existing photo on this device'),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null || !mounted) return;

    final pickFn = widget.onPickPhoto;
    if (pickFn == null) {
      _showMessage('Photo picker handler is not connected.', isError: true);
      return;
    }

    try {
      final pickedPath = await pickFn(context, source);
      if (!mounted || pickedPath == null) return;

      final previous = _photoUrl;
      setState(() => _photoUrl = pickedPath);
      if (previous != null &&
          previous != pickedPath &&
          widget.onDeletePhoto != null) {
        unawaited(widget.onDeletePhoto!(previous));
      }
    } catch (_) {
      if (!mounted) return;
      _showMessage('Could not select photo.', isError: true);
    }
  }

  Future<void> _clearPhoto() async {
    final previous = _photoUrl;
    setState(() => _photoUrl = null);
    if (previous == null) return;
    try {
      await widget.onDeletePhoto?.call(previous);
    } catch (_) {
      if (mounted) _showMessage('Could not remove photo.', isError: true);
    }
  }

  Future<bool> _confirmDiscard() async {
    final hasInput =
        _titleController.text.trim().isNotEmpty ||
        _descriptionController.text.trim().isNotEmpty ||
        _photoUrl != null ||
        (_latitude != null && _longitude != null);

    if (!hasInput) return true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(widget.isEditing ? 'Discard changes?' : 'Discard note?'),
        content: Text(
          widget.isEditing
              ? 'Your edits to this field note will not be saved.'
              : 'You will lose the details entered for this field note.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
              foregroundColor: Theme.of(dialogContext).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _handleDiscard() async {
    if (!await _confirmDiscard()) return;
    if (mounted) Navigator.of(context).pop();
  }

  FieldNote _buildDraftNote(Site site) {
    final existing = widget.editingNote;
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    Location? location;
    if (_latitude != null && _longitude != null) {
      location = Location(
        latitude: _latitude,
        longitude: _longitude,
        label: _locationLabel,
      );
    }

    if (existing != null) {
      return existing.copyWith(
        site: site,
        title: title,
        description: description,
        status: _status,
        occurredAt: _occurredAt,
        location: location,
        photoUrl: _photoUrl,
      );
    }

    return FieldNote(
      id: 0,
      site: site,
      title: title,
      description: description,
      status: _status,
      occurredAt: _occurredAt,
      location: location,
      photoUrl: _photoUrl,
    );
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    final site = _selectedSite;
    if (site == null) {
      setState(() => _siteError = true);
      return;
    }
    if (!isValid) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    final draftNote = _buildDraftNote(site);

    try {
      await widget.onSubmit?.call(draftNote);
      if (!mounted) return;
      Navigator.of(context).pop(draftNote);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showMessage('The note could not be saved.', isError: true);
    }
  }

  Widget _sectionLabel(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 1.1,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _formTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(label, style: theme.textTheme.labelSmall),
      subtitle: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, size: 18),
      onTap: onTap,
    );
  }

  Widget _photoImage(BuildContext context, String path) {
    final scheme = Theme.of(context).colorScheme;
    final ImageProvider provider =
        path.startsWith('http://') || path.startsWith('https://')
        ? NetworkImage(path)
        : FileImage(File(path));

    return Image(
      image: provider,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 200,
      errorBuilder: (_, _, _) => Container(
        height: 200,
        color: scheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selectedSite = _selectedSite;
    final hasLocation = _latitude != null && _longitude != null;
    final photoUrl = _photoUrl;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        unawaited(_handleDiscard());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditing ? 'Edit note' : 'New note'),
          leading: CloseButton(onPressed: _handleDiscard),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xs,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: [
              _sectionLabel(context, 'Visit'),
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _formTile(
                      context: context,
                      icon: Icons.location_on_outlined,
                      label: 'Site',
                      value: selectedSite == null
                          ? (widget.sites.isEmpty
                                ? 'No sites available'
                                : 'Choose a site')
                          : '${selectedSite.name} · ${selectedSite.customer.fullName}',
                      onTap: _pickSite,
                    ),
                    const Divider(height: 1),
                    Row(
                      children: [
                        Expanded(
                          child: _formTile(
                            context: context,
                            icon: Icons.calendar_today_outlined,
                            label: 'Date',
                            value:
                                '${_occurredAt.day.toString().padLeft(2, '0')}/'
                                '${_occurredAt.month.toString().padLeft(2, '0')}/${_occurredAt.year}',
                            onTap: _pickDate,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 44,
                          color: scheme.outlineVariant,
                        ),
                        Expanded(
                          child: _formTile(
                            context: context,
                            icon: Icons.schedule_outlined,
                            label: 'Time',
                            value:
                                '${_occurredAt.hour.toString().padLeft(2, '0')}:'
                                '${_occurredAt.minute.toString().padLeft(2, '0')}',
                            onTap: _pickTime,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_siteError)
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.xs,
                    top: AppSpacing.sm,
                  ),
                  child: Text(
                    'Choose the site this note belongs to.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
              _sectionLabel(context, 'Note'),
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return 'Enter a title.';
                  if (text.length < 3) return 'Use at least 3 characters.';
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g. Rack inspection in Bay 4',
                  prefixIcon: Icon(Icons.title_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                minLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What did you find? What needs to happen next?',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _sectionLabel(context, 'Status'),
              Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _pickStatus,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: Row(
                      children: [
                        StatusChip(status: _status),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            _status.description,
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.expand_more_rounded,
                          size: 20,
                          color: scheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _sectionLabel(context, 'Evidence'),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          hasLocation
                              ? Icons.place_rounded
                              : Icons.location_searching_rounded,
                          size: 18,
                          color: hasLocation
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Location', style: theme.textTheme.labelSmall),
                            const SizedBox(height: 2),
                            Text(
                              hasLocation
                                  ? '${_latitude!.toStringAsFixed(5)}, ${_longitude!.toStringAsFixed(5)}'
                                  : 'No GPS position attached',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_isLocating)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else if (hasLocation)
                        IconButton(
                          tooltip: 'Remove location',
                          onPressed: _clearLocation,
                          icon: const Icon(Icons.close_rounded, size: 18),
                        )
                      else
                        TextButton(
                          onPressed: _captureLocation,
                          child: const Text('Attach'),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (photoUrl == null)
                Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: _pickPhoto,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.photo_camera_outlined,
                              size: 18,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add a photo',
                                  style: theme.textTheme.labelSmall,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Optional · camera or gallery',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.add_a_photo_outlined,
                            size: 18,
                            color: scheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: AppRadius.card,
                          child: _photoImage(context, photoUrl),
                        ),
                        Positioned(
                          top: AppSpacing.sm,
                          right: AppSpacing.sm,
                          child: Material(
                            color: Colors.black54,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _clearPhoto,
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: _pickPhoto,
                        icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                        label: const Text('Replace photo'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border(top: BorderSide(color: scheme.outlineVariant)),
            ),
            child: FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded, size: 18),
              label: Text(widget.isEditing ? 'Save changes' : 'Save note'),
            ),
          ),
        ),
      ),
    );
  }
}
