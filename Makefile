SHELL := /bin/bash

help: ## show this message
	@awk \
		'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
		$(MAKEFILE_LIST)

clean: ## cleanup local files
	@rm -rf \
		./.terraform \
		./.venv \
		./node_modules

fix: fix-tf ## apply all automatic fixes

fix-tf: ## fix terraform files using `terraform fmt`
	@terraform fmt -recursive

lint: ## run all linters
	@echo "no linting configured for this project."

run-pre-commit: ## run pre-commit for all files
	@if [[ -f .pre-commit-config.yaml ]]; then \
		poetry run pre-commit run  $(PRE_COMMIT_OPTS) \
			--all-files \
			--color always; \
	else \
		echo "pre-commit not configured for this project; add a .pre-commit-config.yaml file to configure it."; \
	fi

setup: setup-npm setup-poetry setup-pre-commit setup-tfenv ## setup development environment

setup-npm: ## install node dependencies with npm
	@npm ci

setup-poetry: ## setup python virtual environment
	@if [[ -f poetry.lock ]]; then \
		if [[ -d .venv ]]; then \
			poetry run python -m pip --version >/dev/null 2>&1 || rm -rf ./.venv/* ./.venv/.*; \
			poetry lock --check; \
			poetry install $(POETRY_OPTS) --sync; \
		else \
			poetry lock --check; \
			poetry install $(POETRY_OPTS) --sync; \
		fi \
	fi

setup-pre-commit: ## install pre-commit git hooks
	@if [[ -f .pre-commit-config.yaml ]]; then \
		poetry run pre-commit install; \
	fi

setup-tfenv: ## install terraform using tfenv
	@if [[ "$$(command -v tfenv)" ]]; then \
		tfenv install; \
		terraform init; \
	else \
		echo "tfenv not installed - install it to develop this module"; \
		echo "  - macOS: brew install tfenv"; \
	fi

spellcheck: ## run cspell
	@echo "Running cSpell to checking spelling..."
	@npm exec --no -- cspell lint . \
		--color \
		--config .vscode/cspell.json \
		--dot \
		--gitignore \
		--must-find-files \
		--no-progress \
		--relative \
		--show-context

update: update-pre-commit update-tf-lock ## run all update targets

update-pre-commit: ## update pre-commit hooks
	@if [[ -f .pre-commit-config.yaml ]]; then \
		poetry run pre-commit autoupdate; \
	fi

update-tf-lock: ## update ".terraform.lock.hcl" file
	@terraform init -upgrade
	@terraform providers lock \
		--platform=darwin_arm64 \
		--platform=darwin_amd64 \
		--platform=linux_arm64 \
		--platform=linux_amd64 \
		--platform=windows_amd64
