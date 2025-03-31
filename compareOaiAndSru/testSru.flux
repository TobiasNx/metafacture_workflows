"https://services.dnb.de/sru/zdb"
| open-sru(recordSchema="MARC21plus-xml", query="dnb.isil%3DDE-Sol1",version="1.1",maximumRecords="5",total="20")
| as-records
| write(FLUX_DIR + "testSru.xml");
;
