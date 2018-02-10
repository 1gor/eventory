CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE events (
  number BIGINT NOT NULL,
  id UUID DEFAULT uuid_generate_v4() NOT NULL PRIMARY KEY,
  stream_id UUID NOT NULL,
  stream_version BIGINT NOT NULL,
  type VARCHAR(255) NOT NULL,
  data jsonb NOT NULL,
  recorded_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE UNIQUE INDEX events_number_index ON events USING btree (number);
CREATE INDEX events_stream_id_index ON events USING btree (stream_id);
CREATE INDEX events_recorded_at_index ON events USING btree (recorded_at);

CREATE TABLE event_counter (
  number INT
);
INSERT INTO event_counter (number) VALUES (0);

CREATE TABLE checkpoints (
  id SERIAL PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL,
  position BIGINT NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE INDEX checkpoints_name ON checkpoints (name);
