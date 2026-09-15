import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/features/event/domain/entity/event_status.dart';
import 'package:sports/features/event/domain/entity/sport.dart';
import 'package:sports/features/event/presentation/list/events_filter_view_model.dart';

/// Search box and filter chips above the list.
///
/// Writes to `EventsFilterViewModel` only. The list watches that and reloads
/// itself, so nothing here needs to know the list exists.
class EventsFilterBar extends ConsumerWidget {
  const EventsFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(eventsFilterViewModelProvider);
    final filters = ref.read(eventsFilterViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          TextField(
            onChanged: filters.search,
            textInputAction: .search,
            decoration: const InputDecoration(
              // Titles only for now: the backend has no description search.
              hintText: 'Search events',
              prefixIcon: Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          _ChipRow(
            children: [
              for (final status in EventStatus.values)
                _FilterChip(
                  label: status.label,
                  selected: query.status == status,
                  // Tapping the chip that is on turns the filter off.
                  onSelected: (selected) =>
                      filters.setStatus(selected ? status : null),
                ),
            ],
          ),
          _ChipRow(
            children: [
              for (final sport in Sport.values)
                _FilterChip(
                  label: sport.label,
                  selected: query.sport == sport,
                  onSelected: (selected) =>
                      filters.setSport(selected ? sport : null),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A row of chips that scrolls sideways rather than wrapping, so the bar keeps
/// the same height however many filters there are.
class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: .horizontal,
      child: Row(spacing: 8, children: children),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      visualDensity: .compact,
    );
  }
}
