"https://d-nb.info/1106253078/about/marcxml"
| open-http(accept="application/xml")
| decode-xml
| handle-marcxml
| find-fix-paths(".*ETL.*")
| print
;