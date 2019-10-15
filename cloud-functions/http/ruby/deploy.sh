#!/bin/bash

gcloud functions deploy RbHelloworld --trigger-http --region europe-west1 --runtime=ruby25

