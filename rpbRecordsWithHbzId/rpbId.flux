infile
| open-file
| as-lines
| decode-json
| fix(FLUX_DIR + "rpbHbzId.fix")
| encode-csv(includeHeader="TRUE", separator="\t", noQuotes="true")
| write(FLUX_DIR + "rpbHbzId.tsv")
;