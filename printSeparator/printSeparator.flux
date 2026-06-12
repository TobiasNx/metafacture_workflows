"/home/tobias/Downloads/lobid-resources-bulk-1737026443840.jsonl"
| open-file
| as-lines
| write(FLUX_DIR + "test.xml")
;