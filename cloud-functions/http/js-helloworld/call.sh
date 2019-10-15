#!/bin/bash

# sourcing 
set -e 
echo Sourcing the project id or exiting
source ../../../.env

echo "Found project id: $PROJECT_ID. Now calling the GCGF with parameter :)"

curl -H "Content-Type: application/json" \
 -X POST \
 -d '{"name":"GCF calling from attribute name"}' \
 "https://europe-west1-$PROJECT_ID.cloudfunctions.net/jsHelloGreeting"