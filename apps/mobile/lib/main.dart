import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:sports/core/feedback/providers.dart';
import 'package:sports/routing/router.dart';

void main() {
  installLogSink();
  runApp(const ProviderScope(child: ArenaApp()));
}

void installLogSink() {
  Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '${record.level.name}: ${record.time}: ${record.message} | ${record.error.toString()}',
    );
  });
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
