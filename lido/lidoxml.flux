"http://www.lido-schema.org/documents/examples/LIDO-v1.1-Example_FMobj00154983-LaPrimavera.xml"
| open-http
| decode-xml
// Grund für das nicht erkennen, war die fehlende Bestimmung des Record tags.
// Default ist record. In der Test-Lido Datei gabs das nicht. mit lido klappts.
| handle-generic-xml(emitnamespace="true",recordtagname="lido")

// FLUX_DIR ist eine Variable, die die für den Pfad zum Ordner der Flux-Datei vorgibt.
| fix(FLUX_DIR + "lido.fix")
| encode-json(prettyPrinting="true")
| write(FLUX_DIR + "lido.json")
;