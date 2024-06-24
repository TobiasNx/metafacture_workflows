default infile = FLUX_DIR + "input/UBi_01_Beispiel.xml";
default outfile = FLUX_DIR + "fixOutput/UBi_01_Beispiel_Ergebnis.xml";

// Datei generiert mit:
//$ curl --header "Accept-Encoding: gzip" "http://lobid.org/resources/search?q=_exists_%3A%22zdbId%22+AND+medium.id%3A%22http%3A%2F%2Frdaregistry.info%2FtermList%2FRDAMediaType%2F1003%22&format=jsonl" > ezdb.gz


infile
| open-file
| decode-xml
| handle-generic-xml(emitnamespace="true",attributemarker="@")
| fix(FLUX_DIR + "UBI.fix")
// | batch-reset(batchsize="1")
|encode-xml(recordtag="",roottag="mets:mets",attributemarker="@",valuetag="value")
// Works with next release:
//|encode-xml(recordtag="",roottag="mets:mets",attributemarker="@",valuetag="value", namespaces="__default=http://www.w3.org/TR/html4/\ndcterms=http://purl.org/dc/terms/creator\ndv=http://dfg-viewer.de/\nvl=http://visuallibrary.net/vl\nvls=http://semantics.de/vls\nmarcxml=http://www.loc.gov/MARC21/slim\nepicur=urn:nbn:de:1111-2004033116\noai=http://www.openarchives.org/OAI/2.0/\nzvdd=http://zvdd.gdz-cms.de/\nmets=http://www.loc.gov/METS/\nvlz=http://visuallibrary.net/vlz/1.0\nmods=http://www.loc.gov/mods/v3\nxlink=http://www.w3.org/1999/xlink\nxmlns:mix=http://www.loc.gov/mix/v20\ndc=http://purl.org/dc/elements/1.1/")
//| list-fix-paths
| write(outfile)
;