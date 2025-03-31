FLUX_DIR + inputFile
| open-file
| decode-xml
| handle-generic-xml
| encode-yaml
| write(FLUX_DIR + inputFile + ".out.yaml")
;