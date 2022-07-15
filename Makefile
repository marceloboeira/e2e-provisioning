# Docker
DOCKER ?= `which docker`

# Terraform
TF_ENV ?= `which tfenv`
TF_VERSION_FILE ?= .terraform-version
TF_VERSION ?= `cat ${TF_VERSION_FILE}`
TF_BIN ?= `which terraform`
# List of terraform platforms for terraform to lock
TF_PLATFORMS ?= -platform=linux_arm64 -platform=linux_amd64 -platform=darwin_amd64

# Accounts
ACCOUNTS_FOLDER ?= $(PWD)/accounts
ACCOUNT ?= production
CURRENT_ACCOUNT_FOLDER ?= $(ACCOUNTS_FOLDER)/${ACCOUNT}

.PHONY: help
help: ## List help commands
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-36s\033[0m %s\n", $$1, $$2}'

.PHONY: compose
compose: ## Start all dependencies via docker
	@${DOCKER} compose up

.PHONY: plan
plan: ## Run terraform plan
	@cd ${CURRENT_ACCOUNT_FOLDER}; ${TF_BIN} plan

.PHONY: apply
apply: ## Run terraform apply
	@cd ${CURRENT_ACCOUNT_FOLDER}; ${TF_BIN} apply

.PHONY: lock
init: ## Lock all terraform projects dependencies
	@cd ${CURRENT_ACCOUNT_FOLDER}; ${TF_BIN} init
	@cd ${CURRENT_ACCOUNT_FOLDER}; ${TF_BIN} providers lock ${TF_PLATFORMS}

.PHONY: format
format: ## Format the code
	@cd ${CURRENT_ACCOUNT_FOLDER}; ${TF_BIN} fmt -recursive .

.PHONY: setup
setup: install ## Install all dependencies

.PHONY: install
install_terraform: ## Install terraform version with tfenv
	@${TF_ENV} install ${TF_VERSION}
