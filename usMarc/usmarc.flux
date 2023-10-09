"https://github.com/LibreCat/Catmandu/wiki/files/camel.usmarc"
| open-http(encoding="ascii")
| as-lines
| match(pattern="\\A(.{9}) ", replacement="$1a")
| decode-marc21
| encode-yaml
| print
;
