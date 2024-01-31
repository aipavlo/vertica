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


-- DROP TABLE IF EXISTS md.etl_logging;
CREATE TABLE IF NOT EXISTS md.etl_logging
(
    metadata_id int NOT NULL,
    dwh_id varchar(20) NOT NULL,
    msg varchar(65000),
    start_ts timestamp NOT NULL DEFAULT now(),
    end_ts timestamp
);
CREATE PROJECTION IF NOT EXISTS md.etl_logging_unseg
(
 metadata_id,
 dwh_id,
 msg,
 start_ts,
 end_ts
)
AS
 SELECT etl_logging.metadata_id,
        etl_logging.dwh_id,
        etl_logging.msg,
        etl_logging.start_ts,
        etl_logging.end_ts
 FROM md.etl_logging
 ORDER BY etl_logging.metadata_id,
          etl_logging.dwh_id,
          etl_logging.start_ts
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


-- DROP PROCEDURE IF EXISTS md.audit_columns_logging(schema_list_ varchar(200)) ;
CREATE PROCEDURE IF NOT EXISTS md.audit_columns_logging(schema_list_ varchar(200))
LANGUAGE 'PL/vSQL'
AS 
$$
DECLARE

	start_ts_ timestamp := SELECT DATE_TRUNC('SECOND', SYSDATE);
	step_ts_ timestamp := SELECT DATE_TRUNC('SECOND', SYSDATE);

	step1_s_ integer; -- STEP1 - AUDIT ALL COLUMNS

	metadata_id_ integer; -- id from sessions
	dwh_id_ varchar(20) := 'DWH1';

	step_seconds_ integer;

	c CURSOR FOR 
	SELECT 
	'INSERT INTO md.license_usage (metadata_id, schema_name, table_name, column_name, column_audit) SELECT (SELECT id FROM md.sessions WHERE session_id = (SELECT session_id FROM current_session)) as metadata_id,'''||table_schema||''' AS SCHEMA_NAME, '''||table_name||''' as TABLE_NAME, '''||column_name||''' AS COLUMN_NAME, (SELECT SUM(AUDIT_LENGTH('||column_name||')) FROM '||table_schema||'.'||table_name||') AS AUDIT_SUM ;'
	FROM v_catalog.columns
	WHERE UPPER(column_set_using::VARCHAR(1000)) NOT LIKE '%SELECT%'
	AND UPPER(column_default::VARCHAR(1000)) NOT LIKE '%SELECT%'
	AND table_schema IN (schema_list_);
	query_ varchar(65000);
	
BEGIN
	
	-- CREATE METADATA ID IF NOT EXISTS
	PERFORM INSERT INTO md.sessions (session_id)
			SELECT session_id FROM current_session
			WHERE session_id NOT IN (SELECT session_id FROM md.sessions);

	metadata_id_ := SELECT id FROM md.sessions WHERE session_id = (SELECT session_id FROM current_session);

	-- STEP1 - AUDIT ALL COLUMNS
	FOR query_ IN CURSOR c LOOP
	   EXECUTE query_;
	END LOOP;

	step1_s_ := SELECT DATEDIFF(second, step_ts_, sysdate);
	step_ts_ := SELECT DATE_TRUNC('SECOND', SYSDATE);

	PERFORM SELECT ANALYZE_STATISTICS('md.license_usage');

	-- LOG PROCEDURE
	PERFORM INSERT INTO md.etl_logging (metadata_id, dwh_id, start_ts, end_ts, msg)
	SELECT 
	metadata_id_ AS metadata_id,
	dwh_id_ AS dwh_id,
	start_ts_ AS start_ts,
	SYSDATE AS end_ts,
	TO_JSON(ROW(step1_s_ as step1_s_,
				step_ts_ as step1_ts_)) AS msg;

END;
$$
;

/*
CALL md.audit_columns_logging('public');
SELECT * FROM md.sessions ;
SELECT * FROM md.etl_logging ;
SELECT * FROM md.license_usage ;
SELECT * FROM md.license_usage_cols ;
SELECT DISTINCT schema_name FROM md.license_usage_cols ;
*/
