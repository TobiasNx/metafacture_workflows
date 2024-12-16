//inFile
//| open-file
//| as-lines
//| decode-json
//| fix("replace_all('hbzId','^(.*)$','https://lobid.org/resources/$1.json')
//retain('hbzId')")
//| literal-to-object
//| write(FLUX_DIR + "lobidLinks.txt")
//;

FLUX_DIR + "lobidLinks.txt"
| open-file
| as-lines
| open-http
| as-records
//| catch-object-exception 
| decode-json
| list-fix-values("type[]")
| print
;