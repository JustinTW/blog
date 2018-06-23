# HELP
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ''

.DEFAULT_GOAL := help

build: ## Build Project
	make -C packages/resume build
	make -C packages/blog build

clean: ## Clean the generated/compiles files
	make -C packages/resume clean
	make -C packages/blog clean
