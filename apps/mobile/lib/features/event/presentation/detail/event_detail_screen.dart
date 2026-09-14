import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/core/feedback/feedback_service.dart';
import 'package:sports/core/feedback/providers.dart';
import 'package:sports/features/event/domain/entity/event.dart';
import 'package:sports/features/event/presentation/detail/event_delete_state.dart';
import 'package:sports/features/event/presentation/detail/event_delete_view_model.dart';
import 'package:sports/features/event/presentation/detail/event_detail_view_model.dart';
import 'package:sports/features/event/presentation/list/events_view_model.dart';
import 'package:sports/features/event/presentation/widgets/event_card.dart';
import 'package:sports/routing/routes.dart';
import 'package:sports/shared/widgets/feedbacks/info_widget.dart';

class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this event?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      ref.read(eventDeleteViewModelProvider.notifier).delete(eventId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(eventDetailViewModelProvider(eventId));

    ref.listen<EventDeleteState>(eventDeleteViewModelProvider, (_, next) {
      switch (next) {
        case EventDeleteSuccess():
          ref.read(eventsViewModelProvider.notifier).refresh();
          context.go(Routes.events);
        case EventDeleteFailure(:final error):
          ref.read(feedbackServiceProvider).showError(error.message);
        case EventDeleteIdle():
        case EventDeleteDeleting():
          break;
      }
    });

    final isDeleting =
        ref.watch(eventDeleteViewModelProvider) is EventDeleteDeleting;

    return Scaffold(
      appBar: AppBar(title: Text('Event Detail')),
      body: viewState.when(
        data: (data) => EventDetailBody(
          event: data,
          onEdit: () {
            context.push(Routes.eventForm, extra: data);
          },
          onDelete: isDeleting ? null : () => _confirmDelete(context, ref),
        ),
        error: (error, _) => InfoWidget(
          icon: Icons.error,
          title: error is AppException
              ? error.message
              : 'Something went wrong. Please try again.',
        ),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class EventDetailBody extends StatelessWidget {
  const EventDetailBody({
    super.key,
    required this.event,
    required this.onEdit,
    required this.onDelete,
  });

  final Event event;
  final void Function()? onEdit;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 12,
        crossAxisAlignment: .stretch,
        children: [
          /// For simplicity, reused the Event Card from List
          EventCard(event: event),
          Row(
            crossAxisAlignment: .center,
            children: [
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit'),
              ),
              TextButton.icon(
                onPressed: onDelete,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
