import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 600));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(alpha: 0.45),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.lock_reset_rounded, size: 36, color: colorScheme.primary),
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
                          .scale(
                            begin: const Offset(0.88, 0.88),
                            end: const Offset(1, 1),
                            duration: 450.ms,
                            curve: Curves.easeOutBack,
                          ),
                      const SizedBox(height: 12),
                      Text(
                            'Forgot password?',
                            textAlign: TextAlign.center,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          )
                          .animate(delay: 90.ms)
                          .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
                          .moveY(begin: 8, end: 0, duration: 400.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 6),
                      Text(
                            "Enter the email or phone number linked to your account, and we'll send you a verification code to reset your password.",
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          )
                          .animate(delay: 150.ms)
                          .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
                          .moveY(begin: 8, end: 0, duration: 400.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 28),
                      TextFormField(
                            controller: _identifierController,
                            enabled: !_isSubmitting,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [
                              AutofillHints.email,
                              AutofillHints.username,
                              AutofillHints.telephoneNumberLocal,
                            ],
                            onFieldSubmitted: (_) => _handleReset(),
                            decoration: InputDecoration(
                              labelText: 'Email or phone',
                              hintText: 'name@example.com',
                              prefixIcon: const Icon(Icons.mail_outline_rounded),
                            ),
                            validator: (value) {
                              final trimmed = value?.trim() ?? '';
                              if (trimmed.isEmpty) return 'Enter your email or phone';
                              return null;
                            },
                          )
                          .animate(delay: 200.ms)
                          .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
                          .moveY(begin: 10, end: 0, duration: 380.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 24),
                      SizedBox(
                            height: 48,
                            child: FilledButton(
                              onPressed: _isSubmitting ? null : _handleReset,
                              child: _isSubmitting
                                  ? CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      strokeCap: StrokeCap.round,
                                      color: colorScheme.onPrimary,
                                    )
                                  : const Text('Send Reset Link', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          )
                          .animate(delay: 250.ms)
                          .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
                          .moveY(begin: 10, end: 0, duration: 380.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          onPressed: _isSubmitting ? null : () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text('Back to Sign In'),
                        ),
                      ).animate(delay: 300.ms).fadeIn(duration: 350.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
