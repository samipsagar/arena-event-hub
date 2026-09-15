import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/core/observability/composite_observability_service.dart';
import 'package:sports/core/observability/logger_observability_service.dart';
import 'package:sports/core/observability/observability_service.dart';

/// Single observability entry point for the app.
///
/// Exposed as [ObservabilityService] so nothing downstream depends on the
/// fan-out. Adding Sentry or Firebase later is one more entry in this list.
final observabilityServiceProvider = Provider<ObservabilityService>((ref) {
  return CompositeObservabilityService([LoggerObservability()]);
});
