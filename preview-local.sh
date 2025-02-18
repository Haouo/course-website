#!/bin/bash
docker run -it -d -p 8000:8000 -v ${PWD}:/docs --name material-mkdocs squidfunk/mkdocs-material
