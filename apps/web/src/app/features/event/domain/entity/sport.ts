export const SPORTS = ['FOOTBALL', 'CRICKET', 'RUGBY', 'BASKETBALL', 'TENNIS', 'CHESS'] as const;

export type Sport = (typeof SPORTS)[number];

export const SPORT_LABELS: Record<Sport, string> = {
  FOOTBALL: 'Football',
  CRICKET: 'Cricket',
  RUGBY: 'Rugby',
  BASKETBALL: 'Basketball',
  TENNIS: 'Tennis',
  CHESS: 'Chess',
};
