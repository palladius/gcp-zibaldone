Article: https://opensource.com/article/20/5/helm-charts

it works!

results from installing:

NAME: my-cherry-chart
LAST DEPLOYED: Fri May 15 07:54:57 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services riccardo-cherry-chart)
  export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT