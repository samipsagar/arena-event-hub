/// The sport an event is played in, plus unknown
enum Sport {
  all,
  football,
  cricket,
  rugby,
  basketball,
  tennis,
  chess,
  unknown;

  String get label => switch (this) {
    Sport.all => 'All',
    Sport.football => 'Football',
    Sport.cricket => 'Cricket',
    Sport.rugby => 'Rugby',
    Sport.basketball => 'Basketball',
    Sport.tennis => 'Tennis',
    Sport.chess => 'Chess',
    Sport.unknown => 'Unknown',
  };

  /// Everything but [Sport.unknown]
  static List<Sport> filterable = Sport.values
      .where((s) => s != .unknown)
      .toList();
}
