-- Cursor pagination seeks on (starts_at, id), so the tiebreaker column has to be
-- in the index or the second leg of the comparison falls back to a scan.

DROP INDEX idx_events_starts_at;

CREATE INDEX idx_events_starts_at_id ON events (starts_at, id);
