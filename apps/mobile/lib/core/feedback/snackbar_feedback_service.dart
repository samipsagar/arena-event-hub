import 'package:flutter/material.dart';

import 'feedback_service.dart';

/// How each severity looks and how long it lingers.
///
extension FeedbackUI on FeedbackSeverity {
  Duration get duration => switch (this) {
    FeedbackSeverity.error => const Duration(seconds: 5),
    FeedbackSeverity.warning ||
    FeedbackSeverity.info => const Duration(seconds: 3),
  };

  Color backgroundColor(ColorScheme colors) => switch (this) {
    FeedbackSeverity.error => colors.error,
    FeedbackSeverity.warning => colors.secondary,
    FeedbackSeverity.info => colors.inverseSurface,
  };
}

/// Shows feedback as a snackbar, with no [BuildContext] at the call site.
class SnackBarFeedbackService implements FeedbackService {
  const SnackBarFeedbackService(this._messengerKey);

  final GlobalKey<ScaffoldMessengerState> _messengerKey;

  @override
  void show(FeedbackSeverity severity, String message) {
    final currentState = _messengerKey.currentState;

    if (currentState == null) {
      return;
    }

    currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: severity.backgroundColor(
            Theme.of(currentState.context).colorScheme,
          ),
          duration: severity.duration,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
