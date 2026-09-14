import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/core/feedback/feedback_service.dart';
import 'package:sports/core/feedback/snackbar_feedback_service.dart';

/// Shared as a provider so the app and [feedbackServiceProvider] hold the
/// same instance; without that the service has no messenger to talk to.
final scaffoldMessengerKeyProvider = Provider(
  (ref) => GlobalKey<ScaffoldMessengerState>(),
);

/// Single feedback entry point for the app.
final feedbackServiceProvider = Provider<FeedbackService>((ref) {
  return SnackBarFeedbackService(ref.watch(scaffoldMessengerKeyProvider));
});
