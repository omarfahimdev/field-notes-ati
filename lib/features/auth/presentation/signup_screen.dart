import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/extensions/button_style_extension.dart';
import '../../../core/utils/validators.dart';
import '../application/auth_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() { _name.dispose(); _email.dispose(); _password.dispose(); _confirm.dispose(); super.dispose(); }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(AuthRegisterRequested(name: _name.text.trim(), email: _email.text.trim(), password: _password.text));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: scheme.error));
                  } else if (state is AuthAuthenticated) {
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  }
                },
                builder: (context, state) {
                  final loading = state is AuthLoading;
                  return Form(
                    key: _formKey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Text('Create account', textAlign: TextAlign.center, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      TextFormField(controller: _name, enabled: !loading, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline_rounded)), validator: (v)=>Validators.minLength(v, 2, label: 'Name')),
                      const SizedBox(height: 16),
                      TextFormField(controller: _email, enabled: !loading, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline_rounded)), validator: Validators.email),
                      const SizedBox(height: 16),
                      TextFormField(controller: _password, enabled: !loading, obscureText: _obscure, textInputAction: TextInputAction.next, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline_rounded), suffixIcon: IconButton(onPressed: ()=>setState(()=>_obscure=!_obscure), icon: Icon(_obscure?Icons.visibility_off_outlined:Icons.visibility_outlined))), validator: Validators.password),
                      const SizedBox(height: 16),
                      TextFormField(controller: _confirm, enabled: !loading, obscureText: _obscure, textInputAction: TextInputAction.done, onFieldSubmitted: (_) => _submit(), decoration: const InputDecoration(labelText: 'Confirm password', prefixIcon: Icon(Icons.lock_outline_rounded)), validator: (v)=>Validators.confirmPassword(v, _password.text)),
                      const SizedBox(height: 20),
                      FilledButton(onPressed: loading ? null : _submit, child: const Text('Create account')).withLoading(loading),
                    ]),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
