"https://raw.githubusercontent.com/hbz/nwbib/a69b8e2feafcbde688057644845734c33b86eb47/conf/nwbib-journals.csv"
| open-http
| as-lines
| decode-csv
| fix("replace_all('1','.*(HT.*)','https://lobid.org/resources/search?q=$1+AND+inCollection.id%3A%22https%3A%2F%2Fnwbib.de%2Fjournals%22')
retain('1')")
| literal-to-object
| open-http(accept="application/json")
| as-records
| decode-json
| fix(FLUX_DIR + "additionalFix.fix")
| literal-to-object
| open-http(accept="application/json")
| as-records
| decode-json
| fix("retain('id','title','hbzId')")
| encode-csv(includeHeader="TRUE", separator="\t", noQuotes="true")
| write(FLUX_DIR + "missingLibraries.tsv")
;
