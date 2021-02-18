# This is the base image that we are building off of
# It contains python 3.8.6 and the jupyter notebooks
# Note that this is a fairly large image which is ok for 
# local dev, but a smaller base image would be more appropriate
# for anything that needs to scale
FROM jupyter/datascience-notebook:python-3.8.6

# Rename the default user to alexander (of macedon)
USER root
RUN usermod -l alexander jovyan

USER alexander

RUN pip install kaggle

# Move to the working directory of shrine
WORKDIR /shrine
