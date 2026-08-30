import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_controller.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _fullName = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _fullName.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authControllerProvider.notifier).signUp(
      email: _email.text.trim(),
      username: _username.text.trim(),
      password: _password.text,
      fullName: _fullName.text.trim().isEmpty ? null : _fullName.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final isLoading = auth.isLoading;

    ref.listen(authControllerProvider, (prev, next) {
      final err = next.error;
      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
      }
    });

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Create your account', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _username,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _fullName,
                    decoration: const InputDecoration(labelText: 'Full name (optional)'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => (v == null || v.length < 8) ? 'At least 8 characters' : null,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Sign up'),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Already have an account? Sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
