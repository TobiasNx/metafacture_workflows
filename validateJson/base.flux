"https://lobid.org/resources/search?q=contribution.agent.label%3AMelville&format=jsonl"
| open-http
| as-lines
| decode-json
| encode-json
| validate-json("https://raw.githubusercontent.com/hbz/lobid-resources/refs/heads/master/src/test/resources/schemas/resource.json")
| print
;
