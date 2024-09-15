# Copyright 2024 dah4k
# SPDX-License-Identifier: EPL-2.0

DOCKER      ?= docker
TAG         ?= weather_app
_ANSI_NORM  := \033[0m
_ANSI_CYAN  := \033[36m

.PHONY: help usage
help usage:
	@grep -hE '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?##"}; {printf "$(_ANSI_CYAN)%-20s$(_ANSI_NORM) %s\n", $$1, $$2}'

.PHONY: $(TAG)
$(TAG): Dockerfile
	$(DOCKER) build --tag $(TAG) --file Dockerfile .

.PHONY: all
all: $(TAG) ## Build container image

.PHONY: test
test: $(TAG) ## Test run container image
	$(DOCKER) run --interactive --tty --rm --publish 1337:80 --name=$(TAG) $(TAG)

.PHONY: clean
clean: ## Remove container image
	$(DOCKER) image remove --force $(TAG)

.PHONY: distclean
distclean: clean ## Prune all container images
	$(DOCKER) image prune --force
	$(DOCKER) system prune --force
