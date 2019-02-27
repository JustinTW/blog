# HELP
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ''

.DEFAULT_GOAL := help

test: merge-resume ## Run test
	hackmyresume validate \
	dist/src/fresh/base.json

	hackmyresume validate \
	dist/src/fresh/base-en.json


build: install-deps merge-resume build-web-resume build-pdf-resume publish-resume ## Build Project

clean: ## Clean the generated/compiles files
	rm -rf dist

version: ## output to version
	@echo $(VERSION)

install-deps:
	npm i

merge-resume:
	mkdir -p dist/src/fresh
	mkdir -p dist/src/jrs

	jq -s add \
	resume/about/base.json \
	resume/brief/base.json \
	resume/employment/v2/base.json \
	resume/skill/base.json \
	> dist/src/fresh/base.json

	jq -s add \
	resume/about/base-en.json \
	resume/brief/base-en.json \
	resume/employment/v2/base-en.json \
	resume/skill/base-en.json \
	> dist/src/fresh/base-en.json

	hackmyresume convert dist/src/fresh/base.json dist/src/jrs/base.json
	hackmyresume convert dist/src/fresh/base-en.json dist/src/jrs/base-en.json

	# devops
	jq -s add \
	resume/about/base.json \
	resume/brief/customize/devops.json \
	resume/employment/v2/base.json \
	resume/skill/base.json \
	> dist/src/fresh/devops.json

	jq -s add \
	resume/about/base-en.json \
	resume/brief/customize/devops-en.json \
	resume/employment/v2/base-en.json \
	resume/skill/base-en.json \
	> dist/src/fresh/devops-en.json

	hackmyresume convert dist/src/fresh/devops.json dist/src/jrs/devops.json
	hackmyresume convert dist/src/fresh/devops-en.json dist/src/jrs/devops-en.json

build-web-resume:
	mkdir -p dist/web

	cp -rf node_modules/jsonresume-theme-elegant node_modules/jsonresume-theme-elegant-cht
	cp -rf template/jsonresume-theme-elegant-cht node_modules

	hackmyresume build dist/src/jrs/base.json \
		TO dist/web/resume.html \
		-t node_modules/jsonresume-theme-elegant-cht

	cp -rf node_modules/jsonresume-theme-elegant node_modules/jsonresume-theme-elegant-en
	cp -rf template/jsonresume-theme-elegant-en node_modules
	hackmyresume build dist/src/jrs/base-en.json \
		TO dist/web/resume-en.html \
		-t node_modules/jsonresume-theme-elegant-en

	cp -rf resume/avatar dist/web

build-pdf-resume:
	mkdir -p dist/pdf

	cp -rf node_modules/fresh-theme-compact node_modules/fresh-theme-compact-cht
	cp -rf template/fresh-theme-compact-cht node_modules
	hackmyresume build dist/src/jrs/base.json \
		TO dist/pdf/resume.html \
		-t node_modules/fresh-theme-compact-cht

	cp -rf node_modules/fresh-theme-compact node_modules/fresh-theme-compact-en
	cp -rf template/fresh-theme-compact-en node_modules
	hackmyresume build dist/src/jrs/base-en.json \
		TO dist/pdf/resume-en.html \
		-t node_modules/fresh-theme-compact-en

	# devops
	hackmyresume build dist/src/jrs/devops.json \
		TO dist/pdf/devops.html \
		-t node_modules/fresh-theme-compact-cht

	hackmyresume build dist/src/jrs/devops-en.json \
		TO dist/pdf/devops-en.html \
		-t node_modules/fresh-theme-compact-en

	rm dist/pdf/*.css

publish-resume:
	rm -rf ../blog/source/resume
	mkdir -p ../blog/source/resume
	cp -rf dist/pdf ../blog/source/resume
	cp -rf dist/web ../blog/source/resume
	cp -rf dist/web/* ../blog/source
