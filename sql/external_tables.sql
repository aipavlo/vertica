-- AWS CREDENTIALS
ALTER DATABASE DEFAULT SET AWSRegion='region-region-1';
ALTER DATABASE DEFAULT SET AWSAuth = 'token:token2';

-- EXPORT CSV.GZ
EXPORT TO DELIMITED (directory = 's3://bucket_name/directory_name/', ifDirExists='append', compression='GZIP')
AS
SELECT id, hash_value FROM test.LARGE_HASH_TABLE t LIMIT 200;

-- CREATE EXTERNAL TABLE
DROP TABLE IF EXISTS ext.S3_LARGE_HASH_TABLE;
CREATE EXTERNAL TABLE ext.S3_LARGE_HASH_TABLE
(
    id integer,
    card_hash varchar(256)
)
AS COPY FROM 's3://bucket_name/directory_name/*.csv.gz' GZIP DELIMITER '|' ENCLOSED BY '"';
