# ArgoCD

ArgoCD is a continous deployment tool used for managing K8s deployments. Here we are using helm to manage and deplpoy argocd.

## Deploy argocd into the Cluster

To deploy argoCD into the cluster we need to run the below

```helm dependency build```

this will build the dependecies for us

```helm upgrade --install argocd ./ -f values-aws.yaml -n argocd --set argo-cd.configs.credentialTemplates.https-creds.url=https://github.com/devoptymize/devoptymize-k8ops.git --set argo-cd.configs.credentialTemplates.https-creds.password=<gitlab-password> --set argo-cd.configs.credentialTemplates.https-creds.username=<gitlab-user-name>```

In the above command we are specifying the gitlab connection details, this will ensure the connectivity ti the gitlab repo is etablished along with the helm deployment.


## Dependencies

There is no dependencies as such to have a successful deployment of ArgoCD. W.r.t the ArgoCD ingress, it will be only created once the aws-load-balancer controller is deployed into the cluster. 

To explore more features in values.yaml please refer the officail [values.yaml](https://github.com/argoproj/argo-helm/blob/argo-cd-5.23.5/charts/argo-cd/values.yaml)
