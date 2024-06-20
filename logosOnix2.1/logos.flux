default outfile = FLUX_DIR + "output/output.xml";
directory = FLUX_DIR + "input/";


directory
| read-dir
| open-file
|as-records
// Delete non-existing DTD!
|match(pattern="<!DOCTYPE ONIXmessage SYSTEM.*",replacement="")
|match(pattern="\"http://www.editeur.org/onix/2.1/short/onix-international.dtd\">",replacement="")
|read-string 
|decode-xml
|handle-generic-xml(recordtagname="ONIXmessage", attributemarker="@")
| fix(FLUX_DIR + "onix21.fix")
| encode-xml(attributemarker="@",valuetag="value")
| print
;