"https://raw.githubusercontent.com/LibreCat/Catmandu-MARC/dev/t/rug01.aleph"
| open-http
| as-records(separator="LDR")
| match(pattern="\\A(.{9}) ", replacement="$1a")
| decode-aseq
| encode-yaml
| print
;