"test.flux"
| open-file
| as-records
| decode-json
| fix(transformationFile)
| encode-json(prettyPrinting="true")
| print
;