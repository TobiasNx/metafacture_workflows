"/home/tobias/Downloads/oer_data.mrc(1).xml"
| open-file
| decode-xml
| handle-marcxml
| fix(FLUX_DIR + "marcFilter.fix")
| encode-marcxml
| write(FLUX_DIR + "filtered.xml")
;