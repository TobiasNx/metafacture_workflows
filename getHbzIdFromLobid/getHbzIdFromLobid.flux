"https://raw.githubusercontent.com/hbz/lookup-tables/refs/heads/master/data/almaMmsId2rpbId.tsv"
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
| fix("
move_field('almaMmsId','@almaMmsId')
move_field('@almaMmsId','almaMmsId')
move_field('hbzId','@hbzId')
move_field('@hbzId','hbzId')
unless exists('hbzId')
	add_field('hbzId','')
end
move_field('rpbId','@rpbId')
move_field('@rpbId','rpbId')
unless exists('rpbId')
	add_field('rpbId','')
end

retain('almaMmsId','hbzId','rpbId')")
| encode-csv(includeHeader="TRUE", separator="\t", noQuotes="true")
| write(FLUX_DIR + "rpbLobidMappingWithHT.tsv")
;