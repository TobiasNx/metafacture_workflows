"https://duepublico2.uni-due.de/oer/oai"
| open-oaipmh(metadataPrefix="mods",dateFrom="2021-05-14",dateUntil="2021-05-31")
| as-lines
| write(FLUX_DIR + "testOai.xml");