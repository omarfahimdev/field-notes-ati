import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_info.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/sync/sync_service.dart';
import '../../../../core/theme/app_dimension.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/application/auth_bloc.dart';
import '../../../customers/application/customer_bloc.dart';
import '../../../notes/application/note_bloc.dart';
import '../../../notes/domain/note_status.dart';
import '../../../notes/presentation/widgets/status_chip.dart';
import '../../../notes/presentation/widgets/status_picker_sheet.dart';
import '../../../sites/application/site_bloc.dart';
import '../../application/settings_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final storage = context.read<LocalStorage>();
    final user = storage.user ?? {};
    final name = (user['name'] ?? 'Field user').toString();
    final email = (user['email'] ?? '').toString();
    final initials = name.trim().isEmpty ? 'FU' : name.trim().split(RegExp(r'\s+')).take(2).map((e)=>e[0]).join().toUpperCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.xxxl),
        children: [
          _banner(theme, scheme, context),
          const SizedBox(height: AppSpacing.md),
          _accountCard(theme, scheme, name, email, initials),
          const SizedBox(height: AppSpacing.xxl),
          _section('Preferences', theme),
          _defaultStatusCard(theme, scheme),
          const SizedBox(height: AppSpacing.xxl),
          _section('Sync & storage', theme),
          _syncCard(theme, scheme),
          const SizedBox(height: AppSpacing.md),
          _serverCard(scheme, storage),
          const SizedBox(height: AppSpacing.md),
          _storageCard(theme, scheme),
          const SizedBox(height: AppSpacing.xxl),
          _section('About', theme),
          _aboutCard(theme, scheme),
        ],
      ),
    );
  }

  Widget _section(String t, ThemeData theme) => Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: Text(t, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)));
  void _msg(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Widget _banner(ThemeData theme, ColorScheme scheme, BuildContext context) {
    final pending = context.read<SyncService>().pendingCount;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: scheme.primaryContainer.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Row(children: [
        Icon(pending == 0 ? Icons.cloud_done_outlined : Icons.cloud_upload_outlined, size: 18, color: scheme.onPrimaryContainer),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(pending == 0 ? 'All changes are saved on this device' : '$pending change(s) waiting to sync', style: theme.textTheme.bodySmall?.copyWith(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w600))),
      ]),
    );
  }

  Widget _accountCard(ThemeData theme, ColorScheme scheme, String name, String email, String initials) {
    return Card(child: Column(children: [
      Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Row(children: [
        CircleAvatar(radius: 23, backgroundColor: scheme.primary, child: Text(initials, style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w700))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: theme.textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(email, style: theme.textTheme.bodySmall),
        ])),
      ])),
      const Divider(height: 1),
      Align(alignment: Alignment.centerLeft, child: TextButton.icon(onPressed: () => context.read<AuthBloc>().add(const AuthLogoutRequested()), style: TextButton.styleFrom(foregroundColor: scheme.error), icon: const Icon(Icons.logout_rounded, size: 17), label: const Text('Sign out'))),
    ]));
  }

  Widget _defaultStatusCard(ThemeData theme, ColorScheme scheme) {
    return BlocBuilder<SettingsCubit, NoteStatus>(
      builder: (context, status) {
        return Card(clipBehavior: Clip.antiAlias, child: InkWell(onTap: () async {
          final selected = await showStatusPicker(context, selected: status, title: 'Default note status', subtitle: 'New field notes start with this status.');
          if (selected == null || !mounted) return;
          if (!context.mounted) return;
          await context.read<SettingsCubit>().setDefault(selected);
          if (!mounted) return;
          _msg('New notes will start as ${selected.label}.');
        }, child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Row(children: [
          Icon(Icons.flag_outlined, color: scheme.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Default note status', style: theme.textTheme.titleSmall), const SizedBox(height: 2), Text('Applied to every new field note', style: theme.textTheme.bodySmall)])),
          StatusChip(status: status),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
        ]))));
      },
    );
  }

  Widget _syncCard(ThemeData theme, ColorScheme scheme) {
    final sync = context.read<SyncService>();
    return Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Sync', style: theme.textTheme.titleSmall),
      const SizedBox(height: 4),
      Text('Push local changes and pull latest data from server.', style: theme.textTheme.bodySmall),
      const SizedBox(height: AppSpacing.md),
      SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () async { await sync.sync(); if (mounted) _msg('Sync completed.'); }, icon: const Icon(Icons.sync_rounded, size: 17), label: const Text('Sync now'))),
    ])));
  }

  Widget _serverCard(ColorScheme scheme, LocalStorage storage) {
    final url = storage.baseUrl ?? '';
    return Card(child: Column(children: [
      ListTile(leading: Icon(Icons.cloud_outlined, color: scheme.onSurfaceVariant), title: const Text('Server connection'), subtitle: Text(url.isEmpty ? 'Default: http://localhost:8080' : url, maxLines: 1, overflow: TextOverflow.ellipsis), trailing: const Icon(Icons.chevron_right_rounded), onTap: _editServer),
      const Divider(height: 1),
      ListTile(leading: Icon(Icons.restore_rounded, color: scheme.onSurfaceVariant), title: const Text('Restore from server'), subtitle: const Text('Re-download customers, sites and notes'), onTap: () async { await context.read<SyncService>().pullAll(); if (mounted) _msg('Data refreshed from server.'); }),
    ]));
  }

  Widget _storageCard(ThemeData theme, ColorScheme scheme) {
    final c = context.watch<CustomerBloc>().state.items.length;
    final s = context.watch<SiteBloc>().state.items.length;
    final n = context.watch<NoteBloc>().state.items.length;
    Widget stat(String v, String l) => Expanded(child: Column(children: [Text(v, style: theme.textTheme.titleLarge), Text(l, style: theme.textTheme.labelSmall)]));
    return Card(child: Padding(padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg), child: Row(children: [stat('$c','Customers'), Container(width:1,height:32,color:scheme.outlineVariant), stat('$s','Sites'), Container(width:1,height:32,color:scheme.outlineVariant), stat('$n','Notes')])));
  }

  Widget _aboutCard(ThemeData theme, ColorScheme scheme) {
    return Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(AppInfo.name, style: theme.textTheme.titleSmall),
      const SizedBox(height: 2),
      Text('Version ${AppInfo.version}', style: theme.textTheme.bodySmall),
      const SizedBox(height: AppSpacing.md),
      Text('Offline-first field notes app. Changes are saved locally and synced when online.', style: theme.textTheme.bodySmall),
    ])));
  }

  Future<void> _editServer() async {
    final storage = context.read<LocalStorage>();
    final api = context.read<ApiClient>();
    final url = await showDialog<String>(context: context, builder: (_) => _ServerDialog(initialUrl: storage.baseUrl ?? ''));
    if (url == null || !mounted) return;
    final trimmed = url.trim();
    await storage.setBaseUrl(trimmed.isEmpty ? null : trimmed);
    api.updateBaseUrl(trimmed.isEmpty ? null : trimmed);
    _msg(trimmed.isEmpty ? 'Using default server.' : 'Server URL saved.');
    setState(() {});
  }
}

class _ServerDialog extends StatefulWidget {
  const _ServerDialog({required this.initialUrl});
  final String initialUrl;
  @override
  State<_ServerDialog> createState() => _ServerDialogState();
}
class _ServerDialogState extends State<_ServerDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _controller = TextEditingController(text: widget.initialUrl);
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  void _save() { if (!(_formKey.currentState?.validate() ?? false)) return; Navigator.of(context).pop(_controller.text.trim()); }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Backend server'),
      content: Form(key: _formKey, child: TextFormField(controller: _controller, decoration: const InputDecoration(labelText: 'Base URL', hintText: 'http://10.0.2.2:8080'), validator: Validators.serverUrl, onFieldSubmitted: (_) => _save())),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(''), child: const Text('Use default')),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
