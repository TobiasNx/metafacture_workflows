infile
| open-file
| as-lines
| decode-csv(hasHeader="true", separator="\t")
| fix("replace_all('hbzId','^(.*)$','https://lobid.org/resources/$1.json')
retain('hbzId')")
| literal-to-object
| open-http(accept="application/json")
| as-records
| object-batch-log
| catch-object-exception
| decode-json
| fix(FLUX_DIR + "testAndFilter.fix")
| encode-json
| write(FLUX_DIR + "nzTest.json")
;