SELECT SET_CONFIG_PARAMETER ('AWSRegion','us-west-1');
ALTER SESSION SET AWSAuth='ID:SECRET';

SELECT 'SELECT ADD_LOCATION(' || COALESCE(location_path,'') || ', ' || 
COALESCE(node_name,'') || ', ' || 
COALESCE(location_usage ,'') || ', ' || 
COALESCE(location_label  ,'') || ');'
FROM storage_locations;

SELECT ADD_LOCATION(s3://<name>/<path>, , USER, s3_etl);
