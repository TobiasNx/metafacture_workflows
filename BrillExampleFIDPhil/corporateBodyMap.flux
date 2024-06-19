FLUX_DIR + "MAB-brill/meta.corporatebody"
| open-file
| as-lines
| decode-json
| fix(FLUX_DIR + "map.fix")
| encode-csv(separator="\t", noquotes="true")
| write(FLUX_DIR + "maps/corporateBodyMap.tsv")
;