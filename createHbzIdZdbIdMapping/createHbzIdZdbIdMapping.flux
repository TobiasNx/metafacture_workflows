default infile = "/home/tobias/Schreibtisch/tmp/fix/hbzId2zdbId.json";


infile
| open-file
| as-lines
| decode-json
| batch-log(batchSize="100000")
| encode-csv(includeHeader="TRUE", separator="\t", noQuotes="true")
| write(FLUX_DIR + "hbzId2zdbId.tsv")
;
