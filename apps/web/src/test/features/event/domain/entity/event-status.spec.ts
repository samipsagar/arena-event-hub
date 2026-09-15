import { allowedTransitions } from '@features/event/domain/entity/event-status';

describe('allowedTransitions', () => {
  it('always offers the status it starts from', () => {
    expect(allowedTransitions('SCHEDULED')[0]).toBe('SCHEDULED');
    expect(allowedTransitions('COMPLETED')).toEqual(['COMPLETED']);
  });

  it('mirrors the backend transition map', () => {
    expect(allowedTransitions('SCHEDULED')).toEqual(['SCHEDULED', 'LIVE', 'CANCELLED']);
    expect(allowedTransitions('LIVE')).toEqual(['LIVE', 'COMPLETED', 'CANCELLED']);
  });

  it('leaves terminal states with nowhere to go', () => {
    expect(allowedTransitions('COMPLETED')).toHaveLength(1);
    expect(allowedTransitions('CANCELLED')).toHaveLength(1);
  });
});
