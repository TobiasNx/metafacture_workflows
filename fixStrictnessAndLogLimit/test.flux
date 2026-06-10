FLUX_DIR + "test.jsonl"
| open-file
| as-lines
| decode-json
| change-id(idliteral="id",keepidliteral="true")
| fix(FLUX_DIR + "test.fix", strictness="expression",maxExceptionCount="2")
| encode-yaml
| pringt
;