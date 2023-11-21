#!/bin/bash
#to install aws cli
install_aws () {
      "yum update -y"
      "yum install -y curl jq awscli"
}

# install kubectl
install_kube () {
      curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
      echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
      sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
      export PATH=/usr/local/bin:$PATH
      kubectl version --client
      curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
      chmod 700 get_helm.sh
      ./get_helm.sh
      curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
      sudo mv /tmp/eksctl /usr/local/bin
      eksctl version
}

# add the aws acess key and secret key
connect_cluster () {
      export AWS_ACCESS_KEY_ID=$1
      export AWS_SECRET_ACCESS_KEY=$2
      aws eks --region $3 update-kubeconfig --name $4
}

# deploy argocd
deploy_argocd () {
    cd ../gitops/argocd/kickstart/argocd/
    cloud=$( echo $1 | tr '[:upper:]' '[:lower:]')
    env=$(echo $2 | tr '[:upper:]' '[:lower:]')
    giturl=$(echo $3)
    password=$(echo $4)
    username=$(echo $5)
    helm dependency build
    helm upgrade --install argocd ./ -f values-$cloud-$env.yaml -n argocd --set argo-cd.configs.credentialTemplates.https-creds.url=$giturl --set argo-cd.configs.credentialTemplates.https-creds.password=$password --set argo-cd.configs.credentialTemplates.https-creds.username=$username -n argocd --create-namespace
}

#deploy specific components
deploy_addons () {
    cloud=$(echo $1 | tr '[:upper:]' '[:lower:]')
    cd ../gitops/argocd/techstack/
    helm upgrade --install devoptymize-addons ./ -n devoptymize -f values-$cloud-addons.yaml --create-namespace
}
#deploy secops
deploy_secops () {
    cloud=$(echo $1 | tr '[:upper:]' '[:lower:]')
    stack=$(echo $2 | tr '[:upper:]' '[:lower:]')
    cd ../gitops/argocd/techstack/
    helm upgrade --install devoptymize-secops ./ -n devoptymize -f values-$cloud-$stack.yaml
}
#deploy monitoring components
deploy_monitoring () {
    cloud=$(echo $1 | tr '[:upper:]' '[:lower:]')
    stack=$(echo $2 | tr '[:upper:]' '[:lower:]')
    cd ../gitops/argocd/techstack/
    helm upgrade --install devoptymize-observability-monitoring ./ -n devoptymize -f values-$cloud-$stack.yaml
}

"$@"
