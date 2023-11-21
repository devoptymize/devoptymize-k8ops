## ArgoCD Application manifest

- In argoapps folder we have the YAML files that is used to define and configure an application in ArgoCD for all techstack components.
- This is the sample application manifest file for the components that are under the techstack. If the user is willing to add additional components they can add files similar to this in the same folder.

This ArgoCD Application manifest specifies how to manage and deploy the techstack component application in the "argocd" namespace. It defines the source repository, target namespace, synchronization policy, and Helm-specific values. The application's desired state is defined by the manifests located in the specified Git repository path, and ArgoCD will attempt to maintain the cluster's state in line with this desired state based on the specified settings.
    
    ```
    #
    # Filename: <file_name>.yaml
    # Description: ArgoCD application file for <component_name>
    # Author: CloudifyOps
    # Date: 2023-04-06
    # Version: 1.0
    # License: Copyright (c) [2023] CloudifyOps
    #          This file is licensed under the CloudifyOps.
    #
    ---
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
    name: <component_name>
    namespace: argocd
    annotations:
        argocd.argoproj.io/manifest-generate-paths: <path of the helm folder where the components values.yaml file present>
    labels:
        app.kubernetes.io/name: <custom_name>
        app.kubernetes.io/instance: <custom_name>
        app.kubernetes.io/component: <custom_name>
        app.kubernetes.io/part-of: <custom_name>
    spec:
    destination:
        namespace: <custom_namespace_name>
        server: <Kubernetes API server URL appropriate for your environment>
    project: default
    source:
        path: <path of the helm folder where the components values.yaml file present>
        repoURL: <Your repo URL>
        targetRevision: <Branch name>
        helm:
        valueFiles:
        - <deployment .yaml file for the component>  #You can sepcify multiple files under this
        - <example.yaml file>
    syncPolicy:
        automated:
        prune: true
        selfHeal: true
        allowEmpty: false
        syncOptions:
        - CreateNamespace=true
        - Validate=false
        - SkipDryRunOnMissingResource=true
        - ApplyOutOfSyncOnly=true
        - ServerSideApply=true
    ```


## let's see how a new user can adapt this file to their environment:

- **Application Name** and **Namespace**: Change the name and namespace fields in the metadata section to match the desired name and namespace for your application.

- **Annotations** and **Labels**: Modify the annotations and labels sections to match your own naming conventions and application-specific metadata.

- **Destination Namespace** and **Server**: Update the destination section to specify the target namespace and Kubernetes API server URL appropriate for your environment.

- **Project**: Change the project field to the name of the ArgoCD project you want to associate this application with.

- **Source Configuration**: Update the path, repoURL, targetRevision, and Helm-specific settings (helm) in the source section to point to your Git repository and specify the desired branch or commit.

- **Sync Policy**: Adjust the syncPolicy and syncOptions based on your synchronization requirements. Be cautious with disabling validation (Validate=false) and other settings that might affect the synchronization behavior.

- **Pruning** and **Self-Heal**: Consider whether you want to enable or disable pruning (prune) and self-healing (selfHeal) based on your application's needs and desired maintenance strategy.

- **Additional Helm Values**: If your Helm chart requires additional values files or configuration, add or remove them in the helm section.


