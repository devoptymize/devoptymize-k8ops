# inception.sh

This shell script has a set of functions for automating the installation and deployment of devoptymize k8s components on to a Kubernetes cluster (for now eks clusters)

Let's break down the functions of shell script:

- **install_aws**: Installs the AWS CLI on the system by updating the package manager (yum), and then installing curl, jq, and awscli.
- **install_kube**: Installs kubectl, Helm 3, and eksctl for managing Kubernetes clusters. It downloads and verifies the kubectl binary, sets it up in the system path, and verifies the installation. It also installs Helm 3 and eksctl.
- **connect_cluster**: Sets AWS credentials and configures kubectl to connect to an Amazon EKS (Elastic Kubernetes Service) cluster. It takes AWS access key, secret key, AWS region, and EKS cluster name as arguments.
- **deploy_argocd**: Deploys ArgoCD on the Kubernetes cluster. It navigates to a directory containing ArgoCD Helm charts, performs a dependency build, and then deploys ArgoCD with specific configurations. It takes arguments for the cloud provider, environment, Git URL, password, and username for Git credentials.
- **deploy_addons**: Deploys additional components on the Kubernetes cluster using Helm charts. It takes the cloud provider as an argument and installs components based on configurations in Helm charts.
- **deploy_secops**: Deploys security operations (SecOps) components on the Kubernetes cluster using Helm charts. It takes arguments for the cloud provider and the specific stack (e.g., "secops") to deploy.
- **deploy_monitoring**: Deploys monitoring components on the Kubernetes cluster using Helm charts. It takes arguments for the cloud provider and the specific stack (e.g., "monitoring") to deploy.

### Folder Script and Details
- This script will help you to deploy k8s components like, argocd, addons, secops, monitoring components.

### Use the below commands to run the inception.sh script 

#### To connect to the cluster.
    
- Use the below command by with the required variable values to connect to the cluster. 

``` ./inception.sh connect_cluster <accesskey> <secretkey> <region> <cluster_name> ```
        

#### To deploy and configure ArgoCD.

- This will deploy the argocd and will add integration with our github which is a prerequisite for deploying the k8s components.
        
``` ./inception.sh deploy_argocd <Cloud> <Env> <git_url> <git_password> <git_username> ```
        
    

#### To deploy the AddOns stack.

- This will deploy the addon components. The addon components are the necessary components. We have considered as the mandatory componets list.

``` ./inception.sh deploy_addons <Cloud> ```

    
#### For deploying the SecOps stack, the below command should be used. Which will run the deploy_secops function.

- This will deploy the secops componets based on the list. 

``` ./inception.sh deploy_secops <cloud> <techstack_name>```

    
#### For deploying the Observability stack, the user should use below command. Which will run the deploy_monitoring function.

- This will deploy the observability components form the list which are selected.

``` ./inception.sh deploy_monitoring <cloud> <techstack_name> ```

    
