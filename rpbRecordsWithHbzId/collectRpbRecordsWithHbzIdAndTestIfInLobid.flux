default rpbHarvest = FLUX_DIR + "rpbHarvest.jsonl";

"Start harvesting rpb."
| print;

"http://rpb1.hbz-nrw.de:1990/resources/search?q=_exists_%3AhbzId"
| open-http(header="User-Agent: hbz/rpb-checker", accept="application/x-jsonlines")
| as-lines
| object-batch-log(batchSize="100")
| write(rpbHarvest)
;

"Done harvesting rpb. Start sending requests to lobid."
| print;

rpbHarvest
| open-file
| as-lines
| decode-json
| fix("replace_all('hbzId','^(.*)$','https://lobid.org/resources/$1.json')
retain('hbzId')")
| literal-to-object
| open-http(accept="application/json",header="User-Agent: hbz/rpb-checker")
| as-records
| catch-object-exception
| decode-json
| fix(FLUX_DIR + "getHbzIdFromLobid.fix")
| encode-csv(includeHeader="TRUE", separator="\t", noQuotes="true")
| object-batch-log(batchSize="100")
| write(FLUX_DIR + "rpbLobidMappingWithHT.tsv")
;