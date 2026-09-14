import 'package:flutter/material.dart';
import 'package:sports/shared/widgets/feedbacks/info_widget.dart';

/// Shown in place of the list when there is nothing to show.
class EmptyEventsView extends StatelessWidget {
  const EmptyEventsView({required this.filtered, super.key});

  /// Whether anything is filtering the list, which decides what "empty" means.
  final bool filtered;

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      icon: filtered ? Icons.filter_alt_off_outlined : Icons.event_busy,
      title: filtered ? 'No events match your filters' : 'No events yet',
      detail: filtered
          ? 'Try a different sport, status or search term.'
          : 'Events will show up here once they are scheduled.',
    );
  }
}
