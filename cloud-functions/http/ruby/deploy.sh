#!/bin/bash

gcloud functions deploy rbHelloworld --trigger-http --region europe-west1 --runtime=ruby25

