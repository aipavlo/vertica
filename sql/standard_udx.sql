CREATE OR REPLACE LIBRARY ParquetExportLib AS '/opt/vertica/packages/ParquetExport/lib/libParquetExport.so'; 
CREATE OR REPLACE TRANSFORM FUNCTION public.ParquetExportMulti AS LANGUAGE 'C++' NAME 'ParquetExportMultiFactory' LIBRARY public.ParquetExportLib NOT FENCED;

CREATE OR REPLACE LIBRARY DelimitedExportMulti AS '/opt/vertica/packages/DelimitedExport/lib/libDelimitedExport.so'; 
CREATE OR REPLACE TRANSFORM FUNCTION public.DelimitedExportMulti AS LANGUAGE 'C++' NAME 'DelimitedExportMultiFactory' LIBRARY public.DelimitedExportMulti NOT FENCED;

CREATE OR REPLACE LIBRARY JsonExportMulti AS '/opt/vertica/packages/JsonExport/lib/libJsonExport.so'; 
CREATE OR REPLACE TRANSFORM FUNCTION public.JsonExportMulti AS LANGUAGE 'C++' NAME 'JsonExportMultiFactory' LIBRARY public.JsonExportMulti NOT FENCED;

/*
STANDARD UDX FUNCTIONS 

APPROXIMATE_COUNT_DISTINCT_SYNOPSIS_INFO
APPROXIMATE_MEDIAN
APPROXIMATE_PERCENTILE
AcdDataToCount
AcdDataToLongSyn
AcdDataToSyn
AcdSynToCount
AcdSynToSyn
AdvancedLogTokenizer
BasicLogTokenizer
DELETE_TOKENIZER_CONFIG_FILE
DelimitedExport
DelimitedExportMulti
Edit_Distance
EmptyMap
Explode
FAvroParser
FCefParser
FCsvParser
FDelimitedPairParser
FDelimitedParser
FIDXParser
FJSONParser
FRegexParser
FiveGrams
FlexTokenizer
FourGrams
GET_TOKENIZER_PARAMETER
Jaro_Distance
Jaro_Winkler_Distance
JsonExport
JsonExportMulti
KafkaAvroParser
KafkaCheckBrokers
KafkaExport
KafkaInsertDelimiters
KafkaInsertLengths
KafkaJsonParser
KafkaListManyTopics
KafkaListTopics
KafkaOffsets
KafkaParser
KafkaSource
KafkaTopicDetails
MSE
MapAggregate
MapAggregate
MapContainsKey
MapContainsKey
MapContainsValue
MapContainsValue
MapDelimitedExtractor
MapItems
MapItems
MapJSONExtractor
MapKeys
MapKeys
MapKeysInfo
MapKeysInfo
MapLookup
MapLookup
MapLookup
MapPut
MapRegexExtractor
MapSize
MapSize
MapToString
MapToString
MapValues
MapValues
MapValuesOrField
MapVersion
MapVersion
OrcExport
OrcExportMulti
PRC
ParquetExport
ParquetExportMulti
PickBestType
PickBestType
PickBestType
READ_CONFIG_FILE
ROC
SET_SESSION_PARAMETER
SET_TOKENIZER_PARAMETER
STV_AsGeoJSON
STV_AsGeoJSON
STV_AsGeoJSON
STV_Create_Index
STV_Create_Index
STV_Create_Index
STV_DWithin
STV_DWithin
STV_DWithin
STV_Describe_Index
STV_Drop_Index
STV_Export2Shapefile
STV_Extent
STV_Extent
STV_ForceLHR
STV_Geography
STV_Geography
STV_GeographyPoint
STV_Geometry
STV_Geometry
STV_GeometryPoint
STV_GeometryPoint
STV_GetExportShapefileDirectory
STV_Intersect
STV_Intersect
STV_Intersect
STV_Intersect
STV_Intersect
STV_Intersect
STV_Intersect
STV_Intersect
STV_IsValidReason
STV_IsValidReason
STV_IsValidReason
STV_LineStringPoint
STV_LineStringPoint
STV_LineStringPoint
STV_MemSize
STV_MemSize
STV_MemSize
STV_NN
STV_NN
STV_NN
STV_PolygonPoint
STV_PolygonPoint
STV_PolygonPoint
STV_Refresh_Index
STV_Refresh_Index
STV_Refresh_Index
STV_Rename_Index
STV_Reverse
STV_SetExportShapefileDirectory
STV_ShpCreateTable
STV_ShpParser
STV_ShpSource
ST_Area
ST_Area
ST_Area
ST_AsBinary
ST_AsBinary
ST_AsBinary
ST_AsText
ST_AsText
ST_AsText
ST_Boundary
ST_Buffer
ST_Centroid
ST_Contains
ST_Contains
ST_Contains
ST_ConvexHull
ST_Crosses
ST_Difference
ST_Disjoint
ST_Disjoint
ST_Disjoint
ST_Distance
ST_Distance
ST_Distance
ST_Envelope
ST_Equals
ST_Equals
ST_Equals
ST_GeoHash
ST_GeoHash
ST_GeoHash
ST_GeographyFromText
ST_GeographyFromWKB
ST_GeomFromGeoHash
ST_GeomFromGeoJSON
ST_GeomFromGeoJSON
ST_GeomFromText
ST_GeomFromText
ST_GeomFromWKB
ST_GeomFromWKB
ST_GeometryN
ST_GeometryN
ST_GeometryN
ST_GeometryType
ST_GeometryType
ST_GeometryType
ST_Intersection
ST_Intersects
ST_Intersects
ST_IsEmpty
ST_IsEmpty
ST_IsEmpty
ST_IsSimple
ST_IsSimple
ST_IsSimple
ST_IsValid
ST_IsValid
ST_IsValid
ST_Length
ST_Length
ST_Length
ST_NumGeometries
ST_NumGeometries
ST_NumGeometries
ST_NumPoints
ST_NumPoints
ST_NumPoints
ST_Overlaps
ST_PointFromGeoHash
ST_PointN
ST_PointN
ST_PointN
ST_Relate
ST_SRID
ST_SRID
ST_SRID
ST_Simplify
ST_SimplifyPreserveTopology
ST_SymDifference
ST_Touches
ST_Touches
ST_Touches
ST_Transform
ST_Union
ST_Union
ST_Within
ST_Within
ST_Within
ST_X
ST_X
ST_X
ST_XMax
ST_XMax
ST_XMax
ST_XMin
ST_XMin
ST_XMin
ST_Y
ST_Y
ST_Y
ST_YMax
ST_YMax
ST_YMax
ST_YMin
ST_YMin
ST_YMin
ST_intersects
SetMapKeys
Soundex
Soundex_matches
Stemmer
StemmerCaseInsensitive
StemmerCaseSensitive
StringTokenizer
StringTokenizerDelim
StringTokenizerDelim
Summarize_CatCol
Summarize_CatCol
Summarize_CatCol
Summarize_CatCol
Summarize_CatCol
Summarize_NumCol
ThreeGrams
TwoGrams
Unnest
VoltageSecureAccess
VoltageSecureAccess
VoltageSecureConfigure
VoltageSecureConfigureGlobal
VoltageSecureProtect
VoltageSecureProtect
VoltageSecureProtectAllKeys
VoltageSecureRefreshPolicy
VoltageSecureVersion
WhitespaceLogTokenizer
append_centers
apply_bisecting_kmeans
apply_iforest
apply_inverse_pca
apply_inverse_svd
apply_kmeans
apply_kprototypes
apply_normalize
apply_one_hot_encoder
apply_pca
apply_svd
approximate_quantiles
ar_create_blobs
ar_final_newton
ar_save_model
ar_transition_newton
argmax
argmin
arima_bfgs
arima_line_search
arima_save_model
avg_all_columns_local
bisecting_kmeans_init_model
bk_apply_best_kmeans_results
bk_compute_totss_local
bk_finalize_model
bk_get_rows_in_active_cluster
bk_kmeans_compute_local_centers
bk_kmeans_compute_withinss
bk_kmeans_fast_random_init
bk_kmeans_slow_random_init
bk_kmeanspp_init_cur_cluster
bk_kmeanspp_reset_blob
bk_kmeanspp_select_new_centers
bk_kmeanspp_within_chunk_sum
bk_save_final_model
bk_write_new_cluster_level
blob_to_table
bufUdx
bufUdx
calc_pseudo_centers
calculate_alpha_linear
calculate_hessian_linear1
calculate_hessian_linear2
caseInsensitiveNoStemming
chi_squared
cleanup_kmeans_files
compute_and_save_global_center
compute_and_save_new_centers
compute_local_totss
compute_local_withinss
compute_new_local_centers
confusion_matrix
coordinate_descent_covariance
corr_matrix
count_rows_in_blob
create_aggregator_blob
error_rate
evaluate_naive_bayes_model
evaluate_reg_model
evaluate_svm_model
export_model_files
finalize_blob_resource_group
get_attr_minmax
get_attr_robust_zscore
get_attr_zscore
get_model_attribute
get_model_summary
get_robust_zscore_median
iforest_create_blobs
iforest_phase0_udf1
iforest_phase0_udf2
iforest_phase1_udf1
iforest_phase1_udf2
iforest_phase1_udf3
iforest_phase1_udf4
iforest_phase2_udf1
iforest_phase2_udf2
iforest_phase2_udf3
iforest_phase2_udf4
iforest_save_model
import_model_files
isOrContains
kmeansAddMetricsToModel
kmeans_init_blobs
kmeans_to_write_final_centers
lift_table
line_search_logistic1
line_search_logistic2
listagg
listagg
listagg
listagg
listagg
listagg
listagg
listagg
listagg
listagg
listagg
listagg
listagg
listagg
listagg
listagg
load_rows_into_blocks
map_factor
math_op
matrix_global_xtx
matrix_local_xtx
mode_finder
model_converter
naive_bayes_phase1
naive_bayes_phase1_blob
naive_bayes_phase2
pca_prep1_global
pca_prep1_local
pca_prep2
pmml_parser
predict_arima
predict_autoregressor
predict_linear_reg
predict_logistic_reg
predict_moving_average
predict_naive_bayes
predict_naive_bayes_classes
predict_pmml
predict_poisson_reg
predict_rf_classifier
predict_rf_classifier_classes
predict_rf_regressor
predict_svm_classifier
predict_svm_regressor
predict_xgb_classifier
predict_xgb_classifier_classes
predict_xgb_regressor
random_init
random_init_write
read_from_dfblob
read_map_factor
read_ptree
read_tree
reg_final_bfgs
reg_final_newton
reg_transition_bfgs
reg_transition_newton
reg_write_model
remove_blob
reverse_normalize
rf_blob
rf_clean
rf_phase0_udf1
rf_phase0_udf2
rf_phase1_udf1
rf_phase1_udf2
rf_phase1_udf3
rf_phase1_udf4
rf_phase2_udf1
rf_phase2_udf2
rf_phase2_udf3
rf_phase2_udf4
rf_predictor_importance
rf_save_model
rsquared
save_cv_result
save_pca_model
save_svd_model
save_svm_model
select_new_centers
store_minmax_model
store_one_hot_encoder_model
store_robust_zscore_model
store_zscore_model
table_to_blob
table_to_dfblob
update_and_return_sum_of_squared_distances
upgrade_model_format
writeInitialKmeansModelToDfs
xgb_create_blobs
xgb_phase0_udf1
xgb_phase0_udf2
xgb_phase1_udf1
xgb_phase1_udf2
xgb_phase1_udf3
xgb_phase2_udf1
xgb_phase2_udf2
xgb_phase2_udf3
xgb_predictor_importance
xgb_prune
xgb_save_model
yule_walker

*/
