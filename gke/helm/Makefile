
# for myself..
ricc-chart:
	helm create ricc-chart

#https://opensource.com/article/20/5/helm-charts
buildachart:
	helm create buildachart

#https://opensource.com/article/20/5/helm-charts
helm-install:
	helm install my-cherry-chart buildachart/ --values buildachart/values.yaml | tee helm-instructions.tmp

helm-info:
	@echo Using kubectl to calculate helm chart info:
	@echo POD_NAME=$(kubectl get pods -l "app.kubernetes.io/name=buildachart,app.kubernetes.io/instance=riccardo-cherry-chart" -o jsonpath="{.items[0].metadata.name}")
	@echo NODE_PORT=`kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services riccardo-cherry-chart`
	@echo NODE_IP=`kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}"`
	@echo Export all of that then type this:
	@echo type: kubectl port-forward '$$'POD_NAME 8080:80
