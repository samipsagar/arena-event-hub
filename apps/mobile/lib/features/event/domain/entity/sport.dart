/// The sport an event is played in
enum Sport {
  all,
  football,
  cricket,
  rugby,
  basketball,
  tennis,
  chess;

  String get label => switch (this) {
    Sport.all => 'All',
    Sport.football => 'Football',
    Sport.cricket => 'Cricket',
    Sport.rugby => 'Rugby',
    Sport.basketball => 'Basketball',
    Sport.tennis => 'Tennis',
    Sport.chess => 'Chess',
  };
}
