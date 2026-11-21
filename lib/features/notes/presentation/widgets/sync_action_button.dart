import 'package:flutter/material.dart';

class SyncActionButton extends StatelessWidget {
  final bool isLoading;
  final int count;
  final void Function()? onPressed;
  const SyncActionButton({super.key, this.isLoading = false, this.count = 0, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Center(child: SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2.2))),
          )
        : IconButton(
            tooltip: 'Sync now',
            onPressed: onPressed,
            icon: Badge.count(
              count: 2,
              // count: snapshot.pendingCount,
              // isLabelVisible: snapshot.hasPending,
              child: const Icon(Icons.cloud_sync_outlined, size: 22),
            ),
          );
  }
}
