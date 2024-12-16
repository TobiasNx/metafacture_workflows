// The URL checks lobid for records that are inCollection of RPB but have no rpbId and NO edoweb inCollection.
// These are edoweb records but are missing the url to edoweb due to the url.

"https://lobid.org/resources/search?q=inCollection.id%3A%22http%3A%2F%2Flobid.org%2Fresources%2FHT013494180%23%21%22+AND+NOT+_exists_%3ArpbId+AND+NOT+inCollection.id%3A%22http%3A%2F%2Flobid.org%2Fresources%2FHT016925914%23%21%22&format=json&size=400"
| open-http(accept="application/json")
| as-records
| decode-json(recordPath="member")
| fix("replace_all('almaMmsId','^(.*)$','https://lobid.org/marcxml/$1')
retain('almaMmsId')")
| literal-to-object
| open-http(accept="application/xml")
| decode-xml
| handle-marcxml(namespace="")
| fix(FLUX_DIR + "edoweb.fix")
| encode-yaml
| write(FLUX_DIR + "result.yaml")
;