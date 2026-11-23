import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/sync/sync_service.dart';

class SyncActionButton extends StatefulWidget {
  const SyncActionButton({super.key});

  @override
  State<SyncActionButton> createState() => _SyncActionButtonState();
}

class _SyncActionButtonState extends State<SyncActionButton> {
  bool _loading = false;

  Future<void> _sync() async {
    if (_loading) return;
    setState(() => _loading = true);
    final sync = context.read<SyncService>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      await sync.sync();
      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Sync completed.')));
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Sync failed.')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pending = context.watch<SyncService>().pendingCount;
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Center(child: SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2.2))),
      );
    }
    return IconButton(
      tooltip: 'Sync now',
      onPressed: _sync,
      icon: Badge.count(
        count: pending,
        isLabelVisible: pending > 0,
        child: const Icon(Icons.cloud_sync_outlined, size: 22),
      ),
    );
  }
}
