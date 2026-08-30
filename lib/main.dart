import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: OrqestraApp()));
}

class OrqestraApp extends ConsumerWidget {
  const OrqestraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'Orqestra',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      routerConfig: router,
    );
  }
}
