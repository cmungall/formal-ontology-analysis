#FIND = find db -name "*.db" -print0
FIND = find db/ -name "*.db" -exec bash -c

prep:
	$(FIND) "cat views/bfo.sql | sqlite3 {}" \;

metadata/ontologies.yml:
	wget https://obofoundry.org/registry/ontologies.yml -O $@

metadata/bfo-labels.tsv:
	runoak -i sqlite:obo:bfo labels i^BFO: > $@
metadata/ogms-labels.tsv:
	runoak -i sqlite:obo:ogms labels i^OGMS: > $@

results/ont-axiom-depths.tsv:
	 ./scripts/measure-axiom-depth.pl db/*.owl > $@

results/transitive-universals.tsv:
	runoak -vv -i ontobee: query -q "SELECT DISTINCT ?g ?p ?o WHERE {GRAPH ?g {?r owl:onProperty ?p ; owl:allValuesFrom ?o . ?p rdf:type owl:TransitiveProperty . FILTER(\!strstarts(str(?o), 'http://purl.obolibrary.org/obo/BFO'))}} LIMIT 10000" --no-autolabel > $@

results/q-%.tsv:
	$(FIND) "runoak -i {} query -q 'SELECT '{}' as db, * FROM $*'" \; > $@
