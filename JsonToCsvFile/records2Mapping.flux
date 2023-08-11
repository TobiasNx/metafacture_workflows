default infile = "/home/tobias/git/metafacture_workflows/recordsToCsvMappingFile2/alleAggs.json";

// Datei generiert mit:
//$ curl --header "Accept-Encoding: gzip" "curl --header "Accept-Encoding: gzip" "http://test.lobid.org/organisations/search?q=_exists_:id&format=bulk"  < org.tsv


infile
| open-file 
| as-records
| decode-json(recordPath="aggregations.aggs1.buckets")


| encode-csv(includeHeader="TRUE", separator="\t", noQuotes="true")
| write(FLUX_DIR + "aggs.tsv")
;