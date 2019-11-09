#! /bin/bash

# i cant use the .ernv region as it only supports 4 regions worldwide :/
# basically a knative thing..

. ../../.env

# --[no-]allow-unauthenticated
gcloud beta run deploy helloworld-ruby25 \
   --image    gcr.io/$PROJECT_ID/helloworld-ruby25:latest \
   --platform managed \
   --region   europe-west1 \
   --set-env-vars=COLOR=red \
   --set-env-vars=TARGET=$HOSTNAME-command-line \
   --labels="chiave=valore" \
   --allow-unauthenticated
