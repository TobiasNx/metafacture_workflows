default infile = "/home/tobias/git/metafacture_workflows/recordsToCsvMappingFile/test-org.gz";

// Datei generiert mit:
//$ curl --header "Accept-Encoding: gzip" "curl --header "Accept-Encoding: gzip" "http://test.lobid.org/organisations/search?q=_exists_:id&format=bulk"  < org.tsv


infile
| open-file(compression="gzip")
| as-lines
| decode-json
| fix("retain('id','name' )")
| encode-csv(includeHeader="TRUE", separator="\t", noQuotes="true")
| write(FLUX_DIR + "org-local.tsv")
;