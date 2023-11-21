# SONARQUBE

SonarQube is an open-source platform developed by SonarSource for continuous inspection of code quality to perform automatic reviews with static analysis of code to detect bugs and code smells on 29 programming languages.

## Configure the Ingress inside the values.yaml

- We need a load balancer controller and update the annotations of ingress with
```
ingress:
  enabled: true
  # Used to create an Ingress record.
  hosts:
    - name: <host url>
      # Different clouds or configurations might need /* as the default path
      path: /
      # For additional control over serviceName and servicePort
      serviceName: sonarqube-sonarqube
      servicePort: 9000
      # the pathType can be one of the following values: Exact|Prefix|ImplementationSpecific(default)
      pathType: Prefix
  annotations:
      alb.ingress.kubernetes.io/certificate-arn: <certificate arn>
      alb.ingress.kubernetes.io/group.name: <group name>
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
      alb.ingress.kubernetes.io/load-balancer-name: <loadbalancer name>
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/subnets: <subnet id>
      alb.ingress.kubernetes.io/target-type: ip
      kubernetes.io/ingress.class: <ingress class name>  
```     

## Add the snippet code in sonarqube.yaml(argocd application file)

```
ignoreDifferences:
    - group: apps
      kind: StatefulSet
      name: sonarqube-postgresql
      jsonPointers:
        - /spec/volumeClaimTemplates
```
This configuration may be used to simplify the process of comparing and managing Kubernetes resources by allowing users to ignore specific differences that are not important or expected. It can help to avoid unnecessary alerts or notifications, and reduce the workload of system administrators.

## REFERENCE
[sonarqube](https://docs.sonarqube.org/9.8/setup-and-upgrade/deploy-on-kubernetes/deploy-sonarqube-on-kubernetes/)




