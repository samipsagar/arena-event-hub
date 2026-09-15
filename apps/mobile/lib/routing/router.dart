import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sports/routing/navigation_observer.dart';
import 'package:sports/core/observability/providers.dart';
import 'package:sports/features/event/domain/entity/event.dart';
import 'package:sports/features/event/presentation/detail/event_detail_screen.dart';
import 'package:sports/features/event/presentation/form/event_form_screen.dart';
import 'package:sports/features/event/presentation/list/events_screen.dart';
import 'package:sports/features/startup/presentation/startup_screen.dart';
import 'package:sports/routing/routes.dart';

/// The app's router.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.startup,
    // Named so ObservabilityNavigatorObserver's breadcrumbs say where a
    // person went, rather than "unknown" every time.
    observers: [
      ObservabilityNavigatorObserver(ref.watch(observabilityServiceProvider)),
    ],
    routes: [
      GoRoute(
        name: 'startup',
        path: Routes.startup,
        builder: (_, _) => const StartupScreen(),
      ),
      GoRoute(
        name: 'events',
        path: Routes.events,
        builder: (_, _) => const EventsScreen(),
      ),
      GoRoute(
        name: 'eventDetail',
        path: Routes.eventDetail,
        builder: (_, state) =>
            EventDetailScreen(eventId: state.extra as String),
      ),
      GoRoute(
        name: 'eventForm',
        path: Routes.eventForm,
        builder: (_, state) => EventFormScreen(event: state.extra as Event?),
      ),
    ],
  );
});
