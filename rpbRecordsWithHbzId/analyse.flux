default infile = "/home/tobias/ezdb.gz";


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