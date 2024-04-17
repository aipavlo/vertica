CREATE OR REPLACE LIBRARY ParquetExportLib AS '/opt/vertica/packages/ParquetExport/lib/libParquetExport.so'; 
CREATE OR REPLACE TRANSFORM FUNCTION public.ParquetExportMulti AS LANGUAGE 'C++' NAME 'ParquetExportMultiFactory' LIBRARY public.ParquetExportLib NOT FENCED;

CREATE OR REPLACE LIBRARY DelimitedExportMulti AS '/opt/vertica/packages/DelimitedExport/lib/libDelimitedExport.so'; 
CREATE OR REPLACE TRANSFORM FUNCTION public.DelimitedExportMulti AS LANGUAGE 'C++' NAME 'DelimitedExportMultiFactory' LIBRARY public.DelimitedExportMulti NOT FENCED;

CREATE OR REPLACE LIBRARY JsonExportMulti AS '/opt/vertica/packages/JsonExport/lib/libJsonExport.so'; 
CREATE OR REPLACE TRANSFORM FUNCTION public.JsonExportMulti AS LANGUAGE 'C++' NAME 'JsonExportMultiFactory' LIBRARY public.JsonExportMulti NOT FENCED;
