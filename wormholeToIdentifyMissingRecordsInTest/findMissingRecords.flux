default infile = FLUX_DIR + "orgTestNeu.gz";
default infile2 = FLUX_DIR + "orgTestNeu9000.gz";


// Datei generiert mit:
//$ curl --header "Accept-Encoding: gzip" "curl --header "Accept-Encoding: gzip" "http://test.lobid.org/organisations/search?q=*&format=bulk"  > orgNeu.tsv


infile
| open-file(compression="GZIP")
| as-lines
| decode-json
| fix(
	"copy_field('mainEntityOfPage.dateModified' ,'new')
	retain('new')")
| stream-to-triples
 
| count-triples(countBy="object")
| sort-triples(By="subject" )
| template("${o} | ${s}")
| write(FLUX_DIR + "dateModified.txt")
;