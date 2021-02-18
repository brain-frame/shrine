#!/bin/sh


docker run \
	-v $PWD:/shrine \
	-v ~/.kaggle:/home/jovyan/.kaggle \
	--rm -it shrine $@