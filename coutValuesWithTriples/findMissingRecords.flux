default infile = FLUX_DIR + "lobid_org_test.gz";


// Datei generiert mit:
//$ curl --header "Accept-Encoding: gzip" "curl --header "Accept-Encoding: gzip" "http://test.lobid.org/organisations/search?q=_exists_:id&format=bulk"  < org.tsv


infile
| open-file(compression="GZIP")
| as-lines
| decode-json
| fix("retain('isil')")
| stream-to-triples
| count-triples(countBy="object")
| sort-triples(By="object",numeric="TRUE",order="DECREASING")
| template("${o} | ${s}")
| write(FLUX_DIR + "isil.txt")
;