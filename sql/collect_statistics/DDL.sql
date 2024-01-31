\set ON_ERROR_STOP on

BEGIN;

-- DROP SCHEMA IF EXISTS md CASCADE;
CREATE SCHEMA IF NOT EXISTS md;

-- DROP SEQUENCE IF EXISTS md.Ssessions;
CREATE SEQUENCE IF NOT EXISTS md.Ssessions  CACHE      1 ;

-- DROP TABLE IF EXISTS md.sessions;
CREATE TABLE IF NOT EXISTS md.sessions
(
    id int NOT NULL DEFAULT nextval('md.Ssessions'),
    session_id varchar(80) NOT NULL,
    ts timestamp DEFAULT (now())::timestamptz(6),
    msg varchar(1000),
    CONSTRAINT sessions_UN UNIQUE (session_id) ENABLED,
    CONSTRAINT sessions_PK PRIMARY KEY (id) ENABLED
);
CREATE PROJECTION IF NOT EXISTS md.sessions_unseg
(
 id,
 session_id,
 ts,
 msg
)
AS
 SELECT sessions.id,
        sessions.session_id,
        sessions.ts,
        sessions.msg
 FROM md.sessions
 ORDER BY sessions.id,
          sessions.session_id
UNSEGMENTED ALL NODES;
CREATE PROJECTION IF NOT EXISTS md.sessions_uk_unseg
(
 session_id
)
AS
 SELECT sessions.session_id
 FROM md.sessions
 ORDER BY sessions.session_id
UNSEGMENTED ALL NODES;

-- DROP TABLE IF EXISTS md.license_usage;
CREATE TABLE IF NOT EXISTS md.license_usage
(
    metadata_id int NOT NULL,
    schema_name varchar(150) NOT NULL,
    table_name varchar(500) NOT NULL,
    column_name varchar(500) NOT NULL,
    column_audit int,
    CONSTRAINT license_usage_PK PRIMARY KEY (metadata_id, schema_name, table_name, column_name) ENABLED
);

CREATE PROJECTION IF NOT EXISTS md.license_usage_unseg
(
 metadata_id,
 schema_name,
 table_name,
 column_name,
 column_audit
)
AS
 SELECT license_usage.metadata_id,
        license_usage.schema_name,
        license_usage.table_name,
        license_usage.column_name,
        license_usage.column_audit
 FROM md.license_usage
 ORDER BY metadata_id
UNSEGMENTED ALL NODES;

-- VIEW 
CREATE OR REPLACE VIEW md.license_usage_cols AS
 SELECT (s.ts)::date AS ts,
        u.schema_name,
        u.table_name,
        u.column_name,
        round((u.column_audit / 1000000000::numeric(18,0)), 2) AS gb_current_column,
        round((a.sum_column_audit / 1000000000::numeric(18,0)), 2) AS gb_current_sum,
        round(((100 * u.column_audit) / a.sum_column_audit), 2) AS perc_from_licence_usage
 FROM ((md.license_usage u LEFT  JOIN md.sessions s ON ((u.metadata_id = s.id))) LEFT  JOIN ( SELECT license_usage.metadata_id,
        sum(license_usage.column_audit) AS sum_column_audit
 FROM md.license_usage
 GROUP BY license_usage.metadata_id) a ON ((a.metadata_id = u.metadata_id)))
 ORDER BY (s.ts)::date DESC,
          round(((100 * u.column_audit) / a.sum_column_audit), 2) DESC;
