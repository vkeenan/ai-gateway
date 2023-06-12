.PHONY: build open push pull export sync deploy

build:
	./scripts/build.sh

open:
	./scripts/open.sh

push:
	./scripts/push.sh

pull:
	./scripts/pull.sh

export:
	./scripts/export.sh

sync:
	./scripts/push.sh
	./scripts/pull.sh

deploy:
	./scripts/deploy.sh