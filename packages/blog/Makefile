# HELP
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ''

.DEFAULT_GOAL := help

build: install-deps ## Build Project
	hexo g
	hexo d

publish: ## Publish blog
	hexo d

clean: ## Clean the generated/compiles files
	rm -rf public

version: ## output to version
	@echo $(VERSION)

install-deps:
	yarn
