-- get the status of mergeout
SELECT node_name, schema_name, table_name, request_type, event_type 
FROM mergeout_profiles 
WHERE event_type='REQUEST_QUEUED';

-- create tuple mover task
SELECT DO_TM_TASK('mergeout', 'schema_name.table_name');

-- CREATE MERGEOUT FOR DV FILES
SELECT DO_TM_TASK('dvmergeout');

-- EXECUTE MERGEOUT ONLY FOR CERTAIN PROJECTIONS ACCORDING TO DV FILES AND TO DELETED ROWS
DO
$$
	DECLARE
		c CURSOR FOR 
		SELECT tbl 
			FROM (
				SELECT 
				schema_name||'.'||projection_name AS tbl, sum(deleted_row_count) AS sum_deleted_rows, COUNT(DISTINCT dv_oid) AS cnt_dv_files 
				FROM v_monitor.delete_vectors
				WHERE schema_name = 'stage'
				GROUP BY schema_name, projection_name
				) a
			WHERE cnt_dv_files > 200 ;
		c_ varchar(255);
	BEGIN
		FOR c_ IN CURSOR c LOOP
			RAISE NOTICE 'Output - %', c_ ;
			EXECUTE 'SELECT DO_TM_TASK(''mergeout'', '''|| c_ ||''' )';
			EXECUTE 'SELECT ANALYZE_STATISTICS('''|| c_ ||''', 100)';
		
		END LOOP;
	END;
$$;
