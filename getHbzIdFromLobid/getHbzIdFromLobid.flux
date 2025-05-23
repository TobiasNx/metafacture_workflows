"https://raw.githubusercontent.com/hbz/lookup-tables/c6f9125761c97167ebb80a9a84e6fe92de500766/data/almaMmsId2rpbId.tsv"
| open-http
| as-lines
| decode-csv(separator="\t", hasHeader="true")
| fix("replace_all('almaMmsId','^(.*)$','https://lobid.org/resources/$1')
retain('almaMmsId')")
| literal-to-object
| open-http(accept="application/json")
| as-records
| catch-object-exception
| decode-json
| fix(FLUX_DIR + "getHbzIdFromLobid.fix")
| encode-csv(includeHeader="TRUE", separator="\t", noQuotes="true")
| write(FLUX_DIR + "rpbLobidMappingWithHT.tsv")
;