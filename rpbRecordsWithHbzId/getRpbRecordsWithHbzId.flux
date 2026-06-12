default rpbHarvest = FLUX_DIR + "rpbWithHbzId.jsonl";

// Outcomment to not harvest the data every time.

"Start harvesting rpb."
| print;


"http://rpb1.hbz-nrw.de:1990/resources/search?q=_exists_%3AhbzId+AND+NOT+rpbId%3Af*"
| open-http(header="User-Agent: hbz/rpb-hbzId-checker", accept="application/x-jsonlines")
| as-lines
| write(rpbHarvest)
;


