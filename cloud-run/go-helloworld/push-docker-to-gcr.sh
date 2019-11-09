#!/bin/bash

# push-docker-to-gcr.sh

. ../../.env

gcloud config set project $PROJECT_ID
gcloud builds submit --tag gcr.io/$PROJECT_ID/go-helloworld
