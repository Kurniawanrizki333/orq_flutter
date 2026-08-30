import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_controller.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _login = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _login.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authControllerProvider.notifier).signIn(login: _login.text.trim(), password: _password.text);
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
                  Text('Sign in to Orqestra', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _login,
                    decoration: const InputDecoration(labelText: 'Email or username'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Sign in'),
                  ),
                  TextButton(
                    onPressed: () => context.push('/sign-up'),
                    child: const Text("Don't have an account? Sign up"),
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
