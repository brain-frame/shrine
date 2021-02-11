monument
==============================

A template repo for datascience adapted from Cookiecutter Data Science, but adds a Dockerfile
to build an environment that is machine agnostic (based on Jupyter-datascience image).

Requirements
------------
- Docker Desktop (https://www.docker.com/products/docker-desktop)
- git (https://git-scm.com/downloads)
- make (https://www.gnu.org/software/make/

Steps to get Monument
------------
1. Install prerequisites
2. Clone this repository with 
` git clone https://github.com/brain-frame/monument.git `

NOTE: This is a template repo so you also click "Use this template" 
and create a new repo with the same files as they appear here. Please follow these steps
https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template

and then clone your new repository
` git clone https://github.com/{your_github_username}/{your_new_repo_name}.git `

3. Navigate to the folder 
` cd monument`
4. Build the Docker image (make sure Docker Desktop at the moment)
` make docker_image `
5. Start a Jupyter Notebook
` make jupyter_notebook
6. Get the URL for the Notebook
` make find_jupyter_url `
7. Navigate to the provided URL using your browser of choice
8. Do your DS work
9. Close the server 
` make close_jupyter_notebook `


Sister Git Repositories:
- <a target="_blank" href="https://github.com/brain-frame/granary">granary</a>: A git template repository with a light-weight Docker image for python


Project Organization
------------

    ├── LICENSE
    ├── Makefile           <- Makefile with commands like `make data` or `make train`
    ├── README.md          <- The top-level README for developers using this project.
    ├── data
    │   ├── external       <- Data from third party sources.
    │   ├── interim        <- Intermediate data that has been transformed.
    │   ├── processed      <- The final, canonical data sets for modeling.
    │   └── raw            <- The original, immutable data dump.
    │
    ├── docs               <- A default Sphinx project; see sphinx-doc.org for details
    │
    ├── models             <- Trained and serialized models, model predictions, or model summaries
    │
    ├── notebooks          <- Jupyter notebooks. Naming convention is a number (for ordering),
    │                         the creator's initials, and a short `-` delimited description, e.g.
    │                         `1.0-jqp-initial-data-exploration`.
    │
    ├── references         <- Data dictionaries, manuals, and all other explanatory materials.
    │
    ├── reports            <- Generated analysis as HTML, PDF, LaTeX, etc.
    │   └── figures        <- Generated graphics and figures to be used in reporting
    │
    ├── setup.py           <- makes project pip installable (pip install -e .) so src can be imported
    ├── src                <- Source code for use in this project.
    │   ├── __init__.py    <- Makes src a Python module
    │   │
    │   ├── data           <- Scripts to download or generate data
    │   │   └── make_dataset.py
    │   │
    │   ├── features       <- Scripts to turn raw data into features for modeling
    │   │   └── build_features.py
    │   │
    │   ├── models         <- Scripts to train models and then use trained models to make
    │   │   │                 predictions
    │   │   ├── predict_model.py
    │   │   └── train_model.py
    │   │
    │   └── visualization  <- Scripts to create exploratory and results oriented visualizations
    │       └── visualize.py
    │
    └── Dockerfile         <- Script to create Docker image

Name Reference
------------
The monument is the first building that is able to be constructed in Sid Meier's Civilization 6.
It provides +2 Culture per turn.

--------

<p><small>Project based on the <a target="_blank" href="https://drivendata.github.io/cookiecutter-data-science/">cookiecutter data science project template</a>. #cookiecutterdatascience</small></p>
