import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sports/core/exception/app_exception.dart';
import 'package:sports/features/event/presentation/list/events_filter_view_model.dart';
import 'package:sports/features/event/presentation/list/events_view_model.dart';
import 'package:sports/features/event/presentation/list/widgets/empty_events_view.dart';
import 'package:sports/features/event/presentation/widgets/event_list.dart';
import 'package:sports/features/event/presentation/widgets/events_filter_bar.dart';
import 'package:sports/routing/routes.dart';
import 'package:sports/shared/widgets/feedbacks/info_widget.dart';

/// The events list: what is on, filtered by status, sport and title.
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: const SafeArea(
        child: Column(
          children: [
            EventsFilterBar(),
            Expanded(child: _EventsBody()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(Routes.eventForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EventsBody extends ConsumerWidget {
  const _EventsBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsViewModelProvider);
    final viewModel = ref.read(eventsViewModelProvider.notifier);

    return events.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => InfoWidget(
        icon: Icons.cloud_off,
        title: error is AppException
            ? error.message
            : 'Something went wrong. Please try again.',
        action: FilledButton(
          onPressed: viewModel.refresh,
          child: const Text('Retry'),
        ),
      ),
      data: (state) => RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: state.isEmpty
            ? EmptyEventsView(
                filtered: ref.watch(eventsFilterViewModelProvider).hasFilters,
              )
            : EventList(state: state, onLoadMore: viewModel.loadMore),
      ),
    );
  }
}
