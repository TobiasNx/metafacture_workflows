"http://lobid.org/download/10kAlmaMarc.xml.tar"
| open-http
| open-tar
| decode-xml
| handle-marcxml(namespace="")
| encode-json(prettyPrinting="true")
| print
;