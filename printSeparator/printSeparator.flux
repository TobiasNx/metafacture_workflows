"https://raw.githubusercontent.com/gbv/Catmandu-Tutorial/master/data/marc.mrc"
| open-http
| as-lines
| write(FLUX_DIR + "test", separator="")
;