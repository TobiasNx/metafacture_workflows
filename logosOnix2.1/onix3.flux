default outfile = FLUX_DIR + "output/output.xml";
directory = FLUX_DIR + "input/";


FLUX_DIR + "ONIX3.xml"
| open-file
| decode-xml
| handle-generic-xml(recordtagname="Product", attributemarker="@")
//| fix(FLUX_DIR + "onix21.fix")
| encode-xml(attributemarker="@",valuetag="value",recordTag="Product")
| lines-to-records 
| read-string
| decode-xml
| handle-generic-xml(recordtagname="records", attributemarker="@")
| fix(
	"add_field('header.test.value','TEST')
	move_field('Product','@Product')
	move_field('@Product','Product')"

)
| encode-xml(attributemarker="@",valuetag="value",writeroottag="false",recordTag="ONIXMessage",namespaces="release=3.0")
| write(FLUX_DIR + "text.xml")
;