import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sports/features/event/presentation/list/events_state.dart';
import 'package:sports/features/event/presentation/list/widgets/loading_more_row.dart';
import 'package:sports/features/event/presentation/widgets/event_card.dart';
import 'package:sports/routing/routes.dart';

class EventList extends StatelessWidget {
  const EventList({super.key, required this.state, required this.onLoadMore});

  final EventsState state;
  final VoidCallback onLoadMore;

  static const _loadMoreThreshold = 400.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < _loadMoreThreshold) {
          onLoadMore();
        }

        // Let the notification carry on to anything else listening.
        return false;
      },
      child: ListView.builder(
        // Always scrollable so pull-to-refresh works on a short list too.
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.events.length + (state.hasNext ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.events.length) {
            return const LoadingMoreRow();
          }

          final event = state.events[index];

          return EventCard(
            event: event,
            onTap: () => context.push(Routes.eventDetail, extra: event.id),
          );
        },
      ),
    );
  }
}
