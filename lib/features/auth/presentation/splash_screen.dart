import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_info.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                const Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.45),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.eco_rounded, size: 44, color: colorScheme.primary),
                        )
                        .animate()
                        .fadeIn(duration: 450.ms, curve: Curves.easeOutCubic)
                        .scale(
                          begin: const Offset(0.85, 0.85),
                          end: const Offset(1, 1),
                          duration: 500.ms,
                          curve: Curves.easeOutBack,
                        ),
                    const SizedBox(height: 16),
                    Text(
                          AppInfo.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.4,
                            color: colorScheme.onSurface,
                          ),
                        )
                        .animate(delay: 120.ms)
                        .fadeIn(duration: 450.ms, curve: Curves.easeOutCubic)
                        .moveY(begin: 10, end: 0, duration: 450.ms, curve: Curves.easeOutCubic),
                    const SizedBox(height: 6),
                    Text(
                          AppInfo.tagline,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                        )
                        .animate(delay: 220.ms)
                        .fadeIn(duration: 450.ms, curve: Curves.easeOutCubic)
                        .moveY(begin: 8, end: 0, duration: 450.ms, curve: Curves.easeOutCubic),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    strokeCap: StrokeCap.round,
                    color: colorScheme.primary,
                  ),
                ).animate(delay: 300.ms).fadeIn(duration: 400.ms, curve: Curves.easeOut),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
