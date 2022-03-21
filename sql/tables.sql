CREATE TABLE reader_output (
    reader_id      TEXT      NOT NULL,
    reader_version TEXT      NOT NULL,
    document_id    TEXT      NOT NULL,
    storage_key    TEXT      NOT NULL,
    output_version  TEXT,
    labels          TEXT[],
    timestamp      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE sams_progress (
    event_id            SERIAL PRIMARY KEY,
    document_id         TEXT NOT NULL,
    source_uri          TEXT NOT NULL,
    state               TEXT NOT NULL,
    creation_timestamp  BIGINT NOT NULL,
    is_visible          BOOLEAN NOT NULL,
    cx_id               TEXT,
    metadata            JSONB
);

CREATE TABLE publish_cache (
    document_id       TEXT NOT NULL,
    content TEXT NOT NULL
);

CREATE TABLE pipeline_status (
    id SERIAL PRIMARY KEY,
    document_id TEXT NOT NULL,
    application_id TEXT NOT NULL,
    processor_type TEXT NOT NULL,
    status TEXT NOT NULL,
    scope TEXT NOT NULL,
    start_time BIGINT NOT NULL,
    end_Time BIGINT NOT NULL,
    message TEXT
);

CREATE TABLE ontology_registry (
    id              TEXT        NOT NULL,
    tenant          TEXT        NOT NULL,
    version         INTEGER,
    staging_version INTEGER,
    ontology        TEXT        NOT NULL,
    tags            TEXT[]      DEFAULT array[]::TEXT[],
    timestamp       TIMESTAMPTZ NOT NULL
);

ALTER TABLE ontology_registry ALTER COLUMN tags SET DEFAULT '{}';

CREATE TABLE user_data (
    id        SERIAL    PRIMARY KEY,
    service   TEXT      NOT NULL,
    user_name TEXT      NOT NULL,
    key       TEXT      NOT NULL,
    data      TEXT      NOT NULL,
    ts        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
