enum EventStatus {
  all,
  scheduled,
  live,
  completed,
  cancelled,
  unknown;

  String get label => switch (this) {
    .all => 'All',
    .scheduled => 'Scheduled',
    .live => 'Live',
    .completed => 'Completed',
    .cancelled => 'Cancelled',
    .unknown => 'Unknown',
  };

  /// Everything but [unknown], which nobody can pick.
  static List<EventStatus> filterable = EventStatus.values
      .where((s) => s != .unknown)
      .toList();

  /// Mirrors the backend's `EventStatus.ALLOWED_TRANSITIONS`.
  ///
  static const _allowedTransitions = <EventStatus, List<EventStatus>>{
    EventStatus.scheduled: [EventStatus.live, EventStatus.cancelled],
    EventStatus.live: [EventStatus.completed, EventStatus.cancelled],
    EventStatus.completed: [],
    EventStatus.cancelled: [],
  };

  /// True when this status may move to [target]. Staying put always counts.
  bool canTransitionTo(EventStatus target) =>
      this == target ||
      (_allowedTransitions[this] ?? const []).contains(target);

  /// This status, plus everywhere it may legally move to.
  List<EventStatus> get withAllowedTransitions => [
    this,
    ...?_allowedTransitions[this],
  ];
}
