Um das Flux Script auszuführen müsst ihr euch den MF-Fix Runner runter laden:

https://github.com/metafacture/metafacture-fix/releases

https://metafacture.org/getting-started.html

Um die FLux auszuführen 

`$ ./bin/metafix-runner /path/to/your.flux` auf Unix/Linux/Mac oder
`$ ./bin/metafix-runner.bat /path/to/your.flux` auf Windows

Nutze `list-fix-paths` anstelle von
```
| fix(FLUX_DIR + "lido.fix")
| encode-json(prettyPrinting="true")
```

um die Pfade auszulesen.

