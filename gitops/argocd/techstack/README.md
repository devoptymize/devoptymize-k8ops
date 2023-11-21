# Techstack

Tech stack is a helm chart which deploys the addon components as argocd applications. We have three components now - secops, addons, observability-monitoring. All these will be deployed as helm charts and in the backend the helm chart will deploy argocd applications. Once this chart is deployed, lets say if we are deploying addons - this will deploy addons as an application and inside addon we will have multiple argo applications. This child applciations will be those which are there in the respecive argoapps folder.

## Deploy techstack into the Cluster

To deploy tecstack into the cluster we need to run the below

```shell 
helm upgrade --install devoptymize-addon ./ -n devoptymize -f values-aws-addon.yaml --create-namespace
helm upgrade --install devoptymize-secops ./ -n devoptymize -f values-aws-secops.yaml
helm upgrade --install devoptymize-observability-monitoring ./ -n devoptymize -f values-aws-observability-monitoring.yaml
```
Currently the values.yaml files are set in such a way that we have to deploy addons first, which will deploy the addons along which it will deploy the app-project for us. If we intend to deploy another compoent alone we have to update as below in the respective values.yaml.
```yaml
appproject:
  created: true
  name: devoptymize-k8s-aws-project
```
