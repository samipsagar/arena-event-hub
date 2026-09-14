import 'package:flutter/widgets.dart';
import 'package:sports/core/observability/observability_service.dart';

/// Turns every navigation change into a breadcrumb.
///
class ObservabilityNavigatorObserver extends NavigatorObserver {
  ObservabilityNavigatorObserver(this._observability);

  final ObservabilityService _observability;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _breadcrumb('push', from: previousRoute, to: route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _breadcrumb('pop', from: route, to: previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _breadcrumb('replace', from: oldRoute, to: newRoute);
  }

  void _breadcrumb(
    String action, {
    required Route<dynamic>? from,
    required Route<dynamic>? to,
  }) {
    _observability.addBreadcrumb(
      'Navigation: $action',
      category: 'navigation',
      data: {'from': _nameOf(from), 'to': _nameOf(to)},
    );
  }

  String _nameOf(Route<dynamic>? route) => route?.settings.name ?? 'unknown';
}
