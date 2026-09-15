import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/features/startup/presentation/startup_view_model.dart';

/// The first screen of the app: waits on the startup work, sends the app on
/// where that work points, and offers a way back from a failure.
class StartupScreen extends ConsumerWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(startupViewModelProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        context.go(value);
      }
    });

    final startup = ref.watch(startupViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: .min,
              children: [
                Text('Arena', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 32),
                startup.map(
                  loading: (_) => const CircularProgressIndicator(),
                  data: (_) => const CircularProgressIndicator(),
                  error: (state) => _StartupFailure(
                    message: state.error is AppException
                        ? (state.error as AppException).message
                        : 'Something went wrong. Please try again.',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StartupFailure extends ConsumerWidget {
  const _StartupFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: .min,
      children: [
        Text(
          message,
          textAlign: .center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => ref.read(startupViewModelProvider.notifier).retry(),
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
