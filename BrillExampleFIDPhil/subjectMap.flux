FLUX_DIR + "MAB-brill/meta.subject"
| as-lines
| decode-json
| fix(FLUX_DIR + "map.fix")
| encode-csv(separator="\t", noquotes="true")
| write(FLUX_DIR + "maps/subjectMap.tsv")
;