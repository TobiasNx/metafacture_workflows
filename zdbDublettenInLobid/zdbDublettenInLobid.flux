default infile = "/home/tobias/ezdb.gz";

// Datei generiert mit:
//$ curl --header "Accept-Encoding: gzip" "https://lobid.org/resources/search?q=inCollection.id%3A%22http%3A%2F%2Flobid.org%2Forganisations%2FDE-655%23%21%22+AND+_exists_%3AzdbId&format=jsonnl" > ezdb.gz


infile
| open-file(compression="gzip")
| as-lines
| decode-json
| fix(FLUX_DIR + "ezdbId.fix")
| stream-to-triples(redirect="true")
| sort-triples(by="all")
| collect-triples
| fix(FLUX_DIR + "ezdbId2.fix")
| encode-csv(includeHeader="TRUE", separator="\t", noQuotes="true")
| write(FLUX_DIR + "duplicateZDB_nurNZneu.tsv")
;