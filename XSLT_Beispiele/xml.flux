default infile = "/home/tobias/git/metafacture_workflows/XSLT_Beispiele/BUW01_Einzelband_Ergebnis.xml";

// Datei generiert mit:
//$ curl --header "Accept-Encoding: gzip" "http://lobid.org/resources/search?q=_exists_%3A%22zdbId%22+AND+medium.id%3A%22http%3A%2F%2Frdaregistry.info%2FtermList%2FRDAMediaType%2F1003%22&format=jsonl" > ezdb.gz


infile
| open-file
| decode-xml
| handle-generic-xml(emitnamespace="true", recordtagname="mets",attributemarker="@")
| fix(FLUX_DIR + "test.fix")
//| encode-xml(recordtag="mets",attributemarker="@",valuetag="value")
| list-fix-paths
| write(FLUX_DIR + "output.txt")
;