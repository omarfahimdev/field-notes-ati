import 'package:field_notes/features/auth/presentation/forgot_password_screen.dart';
import 'package:field_notes/features/auth/presentation/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_info.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
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
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: AutofillGroup(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(alpha: 0.45),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.eco_rounded, size: 36, color: colorScheme.primary),
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
                              'Welcome back',
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
                              'Sign in to continue to ${AppInfo.name}',
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
                              textInputAction: TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.username,
                                AutofillHints.email,
                                AutofillHints.telephoneNumberLocal,
                              ],
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
                        const SizedBox(height: 16),
                        TextFormField(
                              controller: _passwordController,
                              enabled: !_isSubmitting,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              onFieldSubmitted: (_) => _handleSignIn(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  onPressed: _isSubmitting
                                      ? null
                                      : () => setState(() => _obscurePassword = !_obscurePassword),
                                  tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    size: 18,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Enter your password';
                                return null;
                              },
                            )
                            .animate(delay: 260.ms)
                            .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
                            .moveY(begin: 10, end: 0, duration: 380.ms, curve: Curves.easeOutCubic),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                                  ),
                            child: const Text('Forgot password?'),
                          ),
                        ).animate(delay: 300.ms).fadeIn(duration: 350.ms),
                        const SizedBox(height: 12),
                        SizedBox(
                              height: 48,
                              child: FilledButton(
                                onPressed: _isSubmitting ? null : _handleSignIn,
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: _isSubmitting
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.2,
                                          strokeCap: StrokeCap.round,
                                          color: colorScheme.onPrimary,
                                        ),
                                      )
                                    : const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            )
                            .animate(delay: 330.ms)
                            .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
                            .moveY(begin: 10, end: 0, duration: 380.ms, curve: Curves.easeOutCubic),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                            TextButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : () =>
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(builder: (context) => SignUpScreen())),
                              child: const Text('Sign Up'),
                            ),
                          ],
                        ).animate(delay: 370.ms).fadeIn(duration: 350.ms),
                      ],
                    ),
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
