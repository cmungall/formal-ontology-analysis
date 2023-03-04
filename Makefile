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

results/q-%.tsv:
	$(FIND) "runoak -i {} query -q 'SELECT '{}' as db, * FROM $*'" \; > $@
