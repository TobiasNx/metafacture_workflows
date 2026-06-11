"http://gnd-proxy.lobid.org/oai/repository"
| open-oaipmh(metadataPrefix="PicaPlus-xml",dateFrom="2025-11-01",setSpec="bib")
| as-lines
| write(FLUX_DIR + "testOai.xml");