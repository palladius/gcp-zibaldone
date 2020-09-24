
deploymentmanager-samples:
	git clone https://github.com/GoogleCloudPlatform/deploymentmanager-samples/

install-l7-lb: deploymentmanager-samples
	./deploy.sh

clean:
	gcloud deployment-manager deployments delete advanced-configuration-l7
