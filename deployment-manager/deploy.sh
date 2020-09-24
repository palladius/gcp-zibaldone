#!/bin/bash

export DEPLOYMENT="forse-funge-l7"
export PRIMARY_ZONE="europe-west6-b"
export SECONDARY_ZONE="us-central1-b"

export ZONE_TO_RUN=$PRIMARY_ZONE
export SECOND_ZONE_TO_RUN=$SECONDARY_ZONE

gcloud deployment-manager deployments create "$DEPLOYMENT" --config deploymentmanager-samples/examples/v2/nodejs_l7/jinja/application.yaml


# export DEPLOYMENT=<DEPLOYMENT NAME>
# export PRIMARY_ZONE=<PRIMARY ZONE>
# export SECONDARY_ZONE=<SECONDARY ZONE>

echo lets now wait for deployment and launch this.. pls give it 30sec...

sleep 30

gcloud compute instance-groups unmanaged set-named-ports ${DEPLOYMENT}-frontend-pri-igm \
 --named-ports http:8080,httpstatic:8080 \
 --zone ${PRIMARY_ZONE}

gcloud compute instance-groups unmanaged set-named-ports ${DEPLOYMENT}-frontend-sec-igm \
 --named-ports http:8080,httpstatic:8080 \
 --zone ${SECONDARY_ZONE}

gcloud compute forwarding-rules list | grep application-