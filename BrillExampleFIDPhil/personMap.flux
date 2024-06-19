FLUX_DIR + "MAB-brill/meta.person"
| open-file
| as-lines
| decode-json
| fix(FLUX_DIR + "personMap.fix")
| encode-csv(separator="\t", noquotes="true")
| write(FLUX_DIR + "maps/personMap.tsv")
;