SELECT 'SELECT ADD_LOCATION(' || COALESCE(location_path,'') || ', ' || 
COALESCE(node_name,'') || ', ' || 
COALESCE(location_usage ,'') || ', ' || 
COALESCE(location_label  ,'') || ');'
FROM storage_locations;

SELECT ADD_LOCATION(s3://<name>/<path>, , USER, s3_etl);
