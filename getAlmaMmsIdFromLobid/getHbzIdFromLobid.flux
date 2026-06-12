FLUX_DIR + "../rpbRecordsWithHbzId/rpbWithHbzId.jsonl"
| open-file
| as-lines
| decode-json
| fix("replace_all('hbzId','^(.*)$','https://lobid.org/resources/$1')
retain('hbzId')")
| literal-to-object
| object-batch-log(batchSize="100")
| open-http(accept="application/json",header="User-Agent: hbz/rpb-hbzId-checker")
| as-records
| catch-object-exception
| decode-json
| fix("
unless any_equal('inCollection[].*.id', 'http://lobid.org/organisations/DE-655#!')
	to_var('almaMmsId','ID')
	log('NO NZ Record: $[ID]', level: 'INFO')
	reject()
end
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
| write(FLUX_DIR + "almaMmsId2HTnumberLobidMappingForRPB.tsv")
;