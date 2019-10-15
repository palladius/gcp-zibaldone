#!/bin/bash

# deploy.sh
#FUNCTION_NAME=${1:-GiveMeADecentArgv1Please}

#gcloud functions deploy "$FUNCTION_NAME" --trigger-http --region europe-west1 --runtime=nodejs8

gcloud functions deploy jsHelloworld --trigger-http --region europe-west1 --runtime=nodejs8
gcloud functions deploy jsHelloGreeting --trigger-http --region europe-west1 --runtime=nodejs8

