"https://raw.githubusercontent.com/LibreCat/Catmandu-MARC/dev/t/rug01.aleph"
| open-http
| as-lines
| decode-aseq
| merge-same-ids // combines the aseq statements in single records. 
| encode-yaml
| print
;