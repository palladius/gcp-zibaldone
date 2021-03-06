#!/bin/bash

# push-docker-to-gcr.sh

. ../../.env

gcloud config set project $PROJECT_ID
gcloud builds submit --tag gcr.io/$PROJECT_ID/helloworld-ruby25

echo See https://console.cloud.google.com/gcr/images/$PROJECT_ID/