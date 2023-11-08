"http://lobid.org/gnd/search?q=*&filter=%2B%28type%3APerson%29&size=9999&format=json"
| open-http(accept="application/json")
| as-records
| decode-json(recordPath="member")
| list-fix-paths(count="false")
| print
;