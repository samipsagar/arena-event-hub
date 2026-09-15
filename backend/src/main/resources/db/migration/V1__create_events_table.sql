-- Events table.

CREATE TABLE events (
    id                      UUID            PRIMARY KEY,
    title                   VARCHAR(120)    NOT NULL,
    sport                   VARCHAR(32)     NOT NULL,
    status                  VARCHAR(32)     NOT NULL,
    venue                   VARCHAR(120)    NOT NULL,
    starts_at               TIMESTAMP WITH TIME ZONE NOT NULL,
    duration_in_minutes     INTEGER         NOT NULL,
    participant_limit       INTEGER         NOT NULL,
    registered_participants INTEGER         NOT NULL DEFAULT 0,
    description             VARCHAR(2000),
    version                 BIGINT          NOT NULL DEFAULT 0,
    created_at              TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at              TIMESTAMP WITH TIME ZONE NOT NULL,

    CONSTRAINT chk_events_status
        CHECK (status IN ('SCHEDULED', 'LIVE', 'COMPLETED', 'CANCELLED')),
    CONSTRAINT chk_events_registered_within_limit
        CHECK (registered_participants >= 0 AND registered_participants <= participant_limit)
);

-- Default ordering and the date-range filter.
CREATE INDEX idx_events_starts_at ON events (starts_at);
