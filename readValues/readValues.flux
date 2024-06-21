default infile = "/home/tobias/git/metafacture_workflows/readValues/org-local.gz";

// Datei generiert mit:
//$ curl --header "Accept-Encoding: gzip" "curl --header "Accept-Encoding: gzip" "http://lobid.org/organisations/search?q=_exists_:id&format=bulk"  < org.tsv


infile
| open-file
| as-lines
| list-fix-values("name")
| write(FLUX_DIR + "names.txt")
;

