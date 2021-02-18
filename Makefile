.PHONY: clean data lint sync_data_to_s3 sync_data_from_s3 \
	docker_image run_docker_image test_environment

#################################################################################
# GLOBALS                                                                       #
#################################################################################

BUCKET = [OPTIONAL] your-bucket-for-syncing-data (do not include 's3://')
PROJECT_NAME = shrine
CONTAINER_NAME = Aigai
PORT = 8801

export PROJECT_NAME

#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Make Dataset
data: .docker_image_record/$(PROJECT_NAME)
	docker run --name $(CONTAINER_NAME) --rm -it $(PROJECT_NAME) python src/data/make_dataset.py data/raw data/processed

## Delete all compiled Python files
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

## Lint using flake8
lint:
	flake8 src

## Upload Data to S3
sync_data_to_s3:
	aws s3 sync data/ s3://$(BUCKET)/data/

## Download Data from S3
sync_data_from_s3:
	aws s3 sync s3://$(BUCKET)/data/ data/

## Test python environment is setup correctly
test_environment: .docker_image_record/$(PROJECT_NAME)
	docker run \
		--name $(CONTAINER_NAME) \
		-v ${CURDIR}:/$(PROJECT_NAME) \
		--rm -it $(PROJECT_NAME) \
		python test_environment.py


#################################################################################
# DOCKER                                                                        #
#################################################################################
.PHONY: docker_image run_docker_image python_shell setup_python bash

.docker_image_record:
	@mkdir -p .docker_image_record

docker_image .docker_image_record/$(PROJECT_NAME): Dockerfile .docker_image_record
	@echo 'Building Docker Image for $(PROJECT_NAME)'
	@set DOCKER_BUILDKIT=1
	@docker build \
		-t $(PROJECT_NAME) \
		.
	@touch .docker_image_record/$(PROJECT_NAME)
	@echo 'Built Docker Image for $(PROJECT_NAME)'

run_docker_image: .docker_image_record/$(PROJECT_NAME)
	docker run \
		--name $(CONTAINER_NAME) \
		-v ${CURDIR}:/$(PROJECT_NAME) \
		--rm -it $(PROJECT_NAME)

python_shell: .docker_image_record/$(PROJECT_NAME)
	docker run \
		--name $(CONTAINER_NAME) \
		-v ${CURDIR}:/$(PROJECT_NAME) \
		--rm -it $(PROJECT_NAME) \
		python

setup_python: setup.py
	docker run \
		--name $(CONTAINER_NAME) \
		-v ${CURDIR}:/$(PROJECT_NAME) \
		--rm -it $(PROJECT_NAME) \
		pip install -e .


bash: .docker_image_record/$(PROJECT_NAME)
	docker run \
		--name $(CONTAINER_NAME) \
		-v ${CURDIR}:/$(PROJECT_NAME) \
		--rm -it $(PROJECT_NAME) \
		bash


#################################################################################
# JUPYTER NOTEBOOK                                                              #
#################################################################################

.PHONY: jupyter_notebook find_jupyter_url close_jupyter_notebook

notebooks:
	@mkdir -p notebooks

jupyter_notebook: .docker_image_record/$(PROJECT_NAME) notebooks
	@echo 'Starting Jupyter Notebook server'
	@docker run \
		--name jupyter_notebook\
		-d \
		-p $(PORT):$(PORT) \
		--rm \
		$(PROJECT_NAME) \
		jupyter notebook --port $(PORT)
	@docker exec jupyter_notebook jupyter notebook list
	@echo 'Replace http://x.x.x.x address with localhost'
	@echo 'URL should look like localhost:8801/?token={long_token}'

find_jupyter_url:
	@docker exec jupyter_notebook jupyter notebook list
	@echo 'Replace http://x.x.x.x address with localhost'
	@echo 'URL should look like localhost:8801/?token={long_token}'

close_jupyter_notebook:
	@echo 'Shutting down Jupyter Notebook server'
	@docker container stop jupyter_notebook


#################################################################################
# PROJECT RULES                                                                 #
#################################################################################

# Add any project rules here

# EXAMPLE PROJECT RULES
# data/interim/data_required.pq: src/pre_processing.py data/raw/raw_data.csv
# 	docker run \
# 		--name $(CONTAINER_NAME) \
# 		-v ${CURDIR}:/$(PROJECT_NAME) \
# 		--rm -it $(PROJECT_NAME) \
# 		python src/pre_processing.py

# data/processed/output.pq: data/interim/data_required.pq src/create_output.py
# 	docker run \
# 		--name $(CONTAINER_NAME) \
# 		-v ${CURDIR}:/$(PROJECT_NAME) \
# 		--rm -it $(PROJECT_NAME) \
# 		python src/create_output.py



#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
