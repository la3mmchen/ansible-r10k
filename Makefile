role := ""
group := ""
GIT_COMMIT_SHORT := $(shell git rev-parse --short HEAD)
IDENTIFIER := $(shell [ -z "${identifier}" ] && echo $(GIT_COMMIT_SHORT) || echo ${identifier})
ANSIBLE_RUNTIME_CONF := ANSIBLE_CONFIG=./ansible.cfg ANSIBLE_LOG_PATH=artefacts/$(IDENTIFIER)-ansible.log

.PHONY: help
help:	## Show this help.
help:
	@echo "wrapper for ansible. loads explicit dependencies for each stage and releases this stuff."
	@echo " "
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	@echo " "
	@echo "params: "
	@echo "	role=<string> [no default value]"
	@echo "	group=<string> [no default value]"
	@echo " "

.PHONY: release
release: ## run a release
release: clearscr dependencies
	@echo "************ release \n"
	@$(ANSIBLE_RUNTIME_CONF) ansible-playbook configs/site.yaml -e identifier=$(IDENTIFIER)

.PHONY: release-check 	
release-check: ## run a release check (ansible --check)
release-check: clearscr dependencies
	@echo "************ release-check \n"
	$(ANSIBLE_RUNTIME_CONF) ansible-playbook --check --diff  configs/site.yaml -e identifier=$(IDENTIFIER)

.PHONY: dependencies
dependencies: ## load dependencies
dependencies:
	@echo "************ loading dependencies \n"
	@$(ANSIBLE_RUNTIME_CONF) ansible-playbook dependencies.yaml -e identifier=$(IDENTIFIER)

.PHONY: role-release
role-release: ## release a given role on a given group (e.g. group=loadbalancer role=keepalived)
role-release: clearscr dependencies
	@echo "************ role-release \n"
	@$(ANSIBLE_RUNTIME_CONF) ansible-playbook --diff -i inventories/hosts configs/role-release.yaml -e identifier=$(IDENTIFIER) -e role=$(role) -e group=$(group)

.PHONY: role-release-check
role-release-check: ## check the release a given role on a given group (ansible --check) (e.g. group=loadbalancer role=keepalived)
role-release-check: dependencies
	@echo "************ role-release-check \n"
	@$(ANSIBLE_RUNTIME_CONF) ansible-playbook --check --diff -i inventories/hosts configs/role-release.yaml -e identifier=$(IDENTIFIER) -e role=$(role) -e group=$(group)

.PHONY: clean
clean: ## clean the sub directories (runtime, inventories, roles, artefacts) that are used as dependency cache
clean:
	@echo "************ clean runtime leftovers \n"
	@rm -rf runtime/*
	@rm -rf inventories/*
	@rm -rf roles/*
	@rm -rf artefacts/$(IDENTIFIER)*

.PHONY: lint
lint:	## lint the yaml files
lint:
	@echo "************ lint yaml files \n"
	/usr/bin/env yamllint *.yaml
	/usr/bin/env yamllint configs/
	@echo "************ lint ansible \n"
	@echo "************ TODO: :P \n"

clearscr:	## clear screen
	clear;
