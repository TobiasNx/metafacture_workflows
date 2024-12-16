"https://lobid.org/resources/search?q=subject.label%3A%22https%3A%2F%2Fw3id.org%2Flobid%2Frpb2%22&format=jsonl"
| open-http
| as-records
| decode-json
| fix(FLUX_DIR + "rpb.fix")
| flatten
| stream-to-triples
| count-triples(countBy = "object")
| sort-triples(by="object", numeric="true", order="decreasing")
| template("${o} | ${s}")
| write(FLUX_DIR + "result.txt")
;
