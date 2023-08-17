current_dir = $(shell pwd)

# First make a symlink to the repo:
# e.g. go -> /Users/cjm/repos/go-ontology


metadata/%-issues.json:
	@(cd $* && gh issue list -s all -L 39999 --json "number,title,state") | grep -v ^/Users > $@
.PRECIOUS: metadata/%-issues.json

metadata-all-%: metadata/%-issues.json
	jq ".[].number"  $< | (cd $* && xargs -I {} sh -c "sleep 0.5 && gh issue view {} -c --json number,title,body,comments,closedAt,createdAt > $(current_dir)/metadata/$*-issue-{}.json && echo ok")

