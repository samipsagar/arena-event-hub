import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sports/features/event/domain/entity/event.dart';
import 'package:sports/features/event/domain/entity/event_status.dart';

/// One event in the list.
class EventCard extends StatelessWidget {
  const EventCard({required this.event, this.onTap, super.key});

  /// Times are already local by the time they reach here — see `EventMapper`.
  static final _when = DateFormat('EEE d MMM • HH:mm');

  final Event event;

  /// Left null where the card is just a display, e.g. on the detail screen.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                crossAxisAlignment: .start,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: .ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(status: event.status),
                ],
              ),
              const SizedBox(height: 8),
              _IconLine(
                icon: Icons.schedule,
                text:
                    '${_when.format(event.startsAt)} • '
                    '${event.durationInMinutes} min',
              ),
              const SizedBox(height: 4),
              _IconLine(
                icon: Icons.place_outlined,
                text: '${event.venue} • ${event.sport.label}',
              ),
              const SizedBox(height: 4),
              _IconLine(
                icon: Icons.group_outlined,
                text: event.isFull
                    ? 'Full — ${event.participantLimit} registered'
                    : '${event.spotsRemaining} of ${event.participantLimit} '
                          'spots left',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The status, coloured by what it means rather than by where it sits.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final EventStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (background, foreground) = switch (status) {
      EventStatus.live || EventStatus.all => (scheme.error, scheme.onError),
      EventStatus.scheduled => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      EventStatus.completed || EventStatus.cancelled || EventStatus.unknown => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: foreground),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall,
            maxLines: 1,
            overflow: .ellipsis,
          ),
        ),
      ],
    );
  }
}
