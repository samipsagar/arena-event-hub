import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/core/feedback/providers.dart';
import 'package:sports/routing/router.dart';

void main() {
  runApp(const ProviderScope(child: ArenaApp()));
}

class ArenaApp extends ConsumerWidget {
  const ArenaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      // Lets FeedbackService show a snackbar from anywhere, with no context.
      scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
      title: 'Arena',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
