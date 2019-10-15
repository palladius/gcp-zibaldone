#!/bin/bash

set -e 
echo Sourcing the project id or exiting
source ../../../.env

echo "Found project id: $PROJECT_ID. Now calling the GCGF with parameter :)"

@echo "1. Call via gcloud.."
gcloud functions call rbHelloworld --region europe-west1

@echo "2. Call via curl.."
curl https://europe-west1-ric-cccwiki.cloudfunctions.net/rbHelloworld

@echo "3. Call via curl with payload.."
curl -H "Content-Type: application/json" \
 -X POST \
 -d '{"name":"GCF calling from attribute name"}' \
 "https://europe-west1-$PROJECT_ID.cloudfunctions.net/rbHelloworld"

