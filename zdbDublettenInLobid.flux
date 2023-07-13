default infile = "/home/user/ezdb.gz";

// Datei generiert mit:
//$ curl --header "Accept-Encoding: gzip" "http://lobid.org/resources/search?q=_exists_%3A%22zdbId%22+AND+medium.id%3A%22http%3A%2F%2Frdaregistry.info%2FtermList%2FRDAMediaType%2F1003%22&format=jsonl" > ezdb.gz


infile
| open-file(compression="gzip")
| as-records
| decode-json
| fix(FLUX_DIR + "ezdbId.fix")
| stream-to-triples(redirect="true")
| sort-triples(by="subject")
| collect-triples
| encode-csv(includeHeader="TRUE", separator="\t", noQuotes="true")
| write(FLUX_DIR + "duplicateZDB.tsv")
;