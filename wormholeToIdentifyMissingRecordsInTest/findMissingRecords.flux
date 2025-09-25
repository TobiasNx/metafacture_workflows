default infile = FLUX_DIR + "lobid_org_test.gz";
default infile2 = FLUX_DIR + "lobid_org.gz";


// Datei generiert mit:
//$ curl --header "Accept-Encoding: gzip" "curl --header "Accept-Encoding: gzip" "http://test.lobid.org/organisations/search?q=_exists_:id&format=bulk"  < org.tsv


infile
| open-file(compression="GZIP")
| as-lines
| decode-json
| fix("retain('id')")
| stream-to-triples
| @X
;

infile2
| open-file(compression="GZIP")
| as-lines
| decode-json
| fix("retain('id')")
| stream-to-triples
| @X
;

@X
| wait-for-inputs("2")
| count-triples(countBy="object")
| sort-triples(By="object",numeric="TRUE")
| template("${o} | ${s}")
| write(FLUX_DIR + "countedId.txt")
;