FLUX_DIR + "MAB-brill/meta.title"
| open-file
| as-lines
| decode-json
| fix(FLUX_DIR + "brill2eisir.fix")
| encode-xml(attributemarker="@",valuetag="value")
| write(FLUX_DIR + "output/eisir.xml")
;