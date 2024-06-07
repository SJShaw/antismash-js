SOURCE_FILES := $(wildcard src/*.ts)

dev: dist/antismash_dev.js

dist/antismash_dev.js: $(SOURCE_FILES)
	rm -f dist/antismash.js
	npm run compile
	./node_modules/.bin/webpack --mode development --output-filename $(notdir $@)
	sed -i "2i /* `git describe --dirty` `git branch --show-current` */" $@

prod: dist/antismash.js

dist/antismash.js: $(SOURCE_FILES)
	npm run lint
	@if ! git describe --exact-match HEAD 2>/dev/null; then echo A git tag matching current HEAD is required. >&2 && exit 1; fi
	npm run compile
	./node_modules/.bin/webpack --mode production
	sed -i "1i /* antismash-js, version `git describe --exact-match HEAD | sed 's/v//g'` */" $@

lint:
	npm run lint

.DEFAULT_GOAL=prod
.PHONY: all lint
