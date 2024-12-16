infile
| open-file
| as-lines
| decode-aseq
| fix("nothing()")
| encode-yaml
| write(FLUX_DIR + outfile + ".yaml")
;