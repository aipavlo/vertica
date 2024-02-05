SELECT 'SELECT ADD_LOCATION(' || COALESCE(location_path,'') || ', ' || 
COALESCE(node_name,'') || ', ' || 
COALESCE(location_usage ,'') || ', ' || 
COALESCE(location_label  ,'') || ');'
FROM storage_locations;

SELECT ADD_LOCATION(s3://vertica-ext-tables/ext_etl/, , USER, s3_ext_etl);
