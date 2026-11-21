import 'package:field_notes/core/utils/extensions/button_style_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_info.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    FocusScope.of(context).unfocus();
    // if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (mounted) {}
      TextInput.finishAutofillContext();
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
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
                              child: Icon(Icons.eco_rounded, size: 36, color: colorScheme.primary),
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
                      const SizedBox(height: 20),
                      Text(
                            'Create account',
                            textAlign: TextAlign.center,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          )
                          .animate(delay: 80.ms)
                          .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
                          .moveY(begin: 8, end: 0, duration: 400.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 6),
                      Text(
                            'Sign up to get started with ${AppInfo.name}',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          )
                          .animate(delay: 130.ms)
                          .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
                          .moveY(begin: 8, end: 0, duration: 400.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 28),
                      TextFormField(
                            controller: _fullNameController,
                            enabled: !_isSubmitting,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.name],
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              hintText: 'John Doe',
                              prefixIcon: const Icon(Icons.person_outline_rounded),
                            ),
                            validator: (value) {
                              final trimmed = value?.trim() ?? '';
                              if (trimmed.isEmpty) return 'Enter your full name';
                              if (trimmed.length < 2) return 'Enter a valid name';
                              return null;
                            },
                          )
                          .animate(delay: 170.ms)
                          .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
                          .moveY(begin: 10, end: 0, duration: 380.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 16),
                      TextFormField(
                            controller: _emailController,
                            enabled: !_isSubmitting,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'name@example.com',
                              prefixIcon: const Icon(Icons.mail_outline_rounded),
                            ),
                            validator: (value) {
                              final trimmed = value?.trim() ?? '';
                              if (trimmed.isEmpty) return 'Enter your email address';
                              if (!trimmed.contains('@') || !trimmed.contains('.')) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          )
                          .animate(delay: 210.ms)
                          .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
                          .moveY(begin: 10, end: 0, duration: 380.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 16),
                      TextFormField(
                            controller: _phoneController,
                            enabled: !_isSubmitting,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.telephoneNumber, AutofillHints.telephoneNumberLocal],

                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              hintText: '01XXXXXXXXX',
                              prefixIcon: const Icon(Icons.phone_outlined),
                            ),
                            validator: (value) {
                              final trimmed = value?.trim() ?? '';
                              if (trimmed.isEmpty) return 'Enter your phone number';
                              final digitsOnly = trimmed.replaceAll(RegExp(r'\D'), '');
                              if (digitsOnly.length < 10) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          )
                          .animate(delay: 250.ms)
                          .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
                          .moveY(begin: 10, end: 0, duration: 380.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 16),
                      TextFormField(
                            controller: _passwordController,
                            enabled: !_isSubmitting,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.newPassword],
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
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Create a password';
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          )
                          .animate(delay: 290.ms)
                          .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
                          .moveY(begin: 10, end: 0, duration: 380.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 16),
                      TextFormField(
                            controller: _confirmPasswordController,

                            enabled: !_isSubmitting,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.newPassword],
                            onFieldSubmitted: (_) => _handleSignUp(),
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : () => setState(() => _obscurePassword = !_obscurePassword),
                                tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          )
                          .animate(delay: 330.ms)
                          .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
                          .moveY(begin: 10, end: 0, duration: 380.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 24),
                      FilledButton(
                            onPressed: _isSubmitting ? null : _handleSignUp,
                            child: const Text('Create Account', style: TextStyle(fontWeight: FontWeight.w600)),
                          )
                          .withLoading(_isSubmitting)
                          .animate(delay: 370.ms)
                          .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
                          .moveY(begin: 10, end: 0, duration: 380.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                          TextButton(
                            onPressed: _isSubmitting ? null : () => Navigator.of(context).maybePop(),
                            child: const Text('Sign In'),
                          ),
                        ],
                      ).animate(delay: 410.ms).fadeIn(duration: 350.ms),
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
