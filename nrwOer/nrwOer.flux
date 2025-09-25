"https://oersi.org/resources/api/search/oer_data/_search?q=creator.location.address.addressRegion:%22North%20Rhine-Westphalia%22+OR+creator.affiliation.location.address.addressRegion:%22North%20Rhine-Westphalia%22+OR+publisher.location.address.addressRegion:%22North%20Rhine-Westphalia%22+OR+sourceOrganization.location.address.addressRegion:%22North%20Rhine-Westphalia%22&size=9999"
| open-http(accept="application/json")
| as-records
| decode-json(recordPath="hits.hits.*._source")
| fix(FLUX_DIR + "nrwOer.fix")
| flatten
| encode-csv(includeHeader="true")
| write(FLUX_DIR + "nrw-resources.csv")
;