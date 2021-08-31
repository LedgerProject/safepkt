SHELL:=/bin/bash

.PHONY: help install install-frontend install-backend run-backend run-frontend copy-configuration-files

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

contribution: run-frontend ## Run SafePKT backend and frontend for contribution

copy-configuration-files: ## Copy default configuration files
	cd frontend && make copy-configuration-file && \
	cd ../backend && make copy-configuration-file

install-backend-deps: ## Install backend dependencies
	cd backend && \
	make clone-rvt && \
	make pull-rvt-container-image && \
	make make-runtime && \
	make install-deps

install-frontend-deps: ## Install frontend dependencies
	cd frontend && npm install

install: copy-configuration-files install-backend-deps install-frontend-deps ## Install SafePKT

run-backend: ## Run backend
	cd backend && make release && make development-server

run-frontend: run-backend ## Run frontend
	cd frontend && make development-server
