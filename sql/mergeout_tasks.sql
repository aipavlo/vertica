-- get the status of mergeout
SELECT node_name, schema_name, table_name, request_type, event_type 
FROM mergeout_profiles 
WHERE event_type='REQUEST_QUEUED';

-- create tuple mover task
SELECT DO_TM_TASK('mergeout', 'schema_name.table_name');
