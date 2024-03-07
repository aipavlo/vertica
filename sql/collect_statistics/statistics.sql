-- Find expensive queries with problems
SELECT USER_NAME, EVENT_TYPE, COUNT(EVENT_TYPE) AS cnt
FROM query_events
WHERE event_timestamp > sysdate -7
AND USER_NAME != 'dbadmin'
AND event_severity = 'Critical'
GROUP BY USER_NAME, EVENT_TYPE
ORDER BY COUNT(EVENT_TYPE) DESC 
LIMIT 100 ;

-- Intent locks 
SELECT * FROM LOCKS WHERE LOCK_MODE='I';
