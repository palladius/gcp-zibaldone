
deploymentmanager-samples:
	git clone https://github.com/GoogleCloudPlatform/deploymentmanager-samples/

install-l7-lb: deploymentmanager-samples
	gcloud deployment-manager deployments create advanced-configuration-l7 --config deploymentmanager-samples/examples/v2/nodejs_l7/jinja/application.yaml

