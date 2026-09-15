import {
  eventToDomain,
  eventsToDomain,
  formDataToCreateRequest,
  formDataToUpdateRequest,
} from '@features/event/data/mapper/event.mapper';
import { EventMock } from '../../../../mocks/event-mock';

describe('eventToDomain', () => {
  it('maps a dto onto the entity the app uses', () => {
    expect(eventToDomain(EventMock.dto())).toEqual(EventMock.entity());
  });

  it('keeps the wire timestamps as dates', () => {
    const event = eventToDomain(EventMock.dto());

    expect(event.startsAt.toISOString()).toBe('2026-03-14T18:30:00.000Z');
    expect(event.endsAt.toISOString()).toBe('2026-03-14T20:00:00.000Z');
  });

  it('maps a page of dtos in order', () => {
    const events = eventsToDomain([EventMock.dto({ id: 'a' }), EventMock.dto({ id: 'b' })]);

    expect(events).toEqual([EventMock.entity({ id: 'a' }), EventMock.entity({ id: 'b' })]);
  });
});

describe('formDataToCreateRequest', () => {
  it('sends no status: a new event is always scheduled by the backend', () => {
    const body = formDataToCreateRequest(EventMock.formData());

    expect(body).not.toHaveProperty('status');
  });

  it('sends the start time as an ISO-8601 string', () => {
    const body = formDataToCreateRequest(EventMock.formData());

    expect(body.startsAt).toBe('2026-03-14T18:30:00.000Z');
  });
});

describe('formDataToUpdateRequest', () => {
  it('adds the status the create body leaves out', () => {
    const body = formDataToUpdateRequest(EventMock.formData({ status: 'LIVE' }));

    expect(body.status).toBe('LIVE');
    expect(body).toMatchObject(formDataToCreateRequest(EventMock.formData({ status: 'LIVE' })));
  });
});
