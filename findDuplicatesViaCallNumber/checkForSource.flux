FLUX_DIR + "mün.csv"
| open-file
| as-lines
| decode-csv(hasHeader="true")
| change-id(idliteral="Signatur",keepidliteral="true")
| fix("add_field('source','mün') retain('Signatur', 'source')")
| stream-to-triples
| @x;

FLUX_DIR + "testNeuNoCount.tsv"
| open-file
| as-lines
| decode-csv(hasHeader="true",separator="\t")
| change-id(idliteral="callNumber",keepidliteral="true")
| stream-to-triples
| @x;

@x
|wait-for-inputs("2")
|sort-triples
|collect-triples
|encode-csv
|write(FLUX_DIR + "result.txt");