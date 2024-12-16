infile
| open-file
| as-lines
| decode-mab
//| decode-marc21
| fix("nothing()")
| encode-yaml
| write(FLUX_DIR + outfile + ".yaml")
;