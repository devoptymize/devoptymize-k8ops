# Chart files and Helm chart configuration files

- In this helm folder we have Chart.yaml files and values.yaml files for all the techstack components.

- The Chart.yaml file and the accompanying Helm chart configuration file provide details for deploying "components" using Helm, a package manager for Kubernetes applications.

Chart.yaml provides metadata about the Helm chart, while the Helm chart configuration file (typically values.yaml) allows you to customize the components deployment by overriding default values. Helm combines these files to deploy and configure the components on your Kubernetes cluster as per your requirements.

- The values.yaml file should contains the configurations for component which is specified in the Helm chart.

- Here is the sample Chart.yaml(Helm chart) file shown below. where the user can adapt this file to their environment for the specific component.

### Chart.yaml


    #
    # Filename: Chart.yaml
    # Description: Chart description file for the component
    # Author: CloudifyOps
    # Date: 2023-04-06
    # Version: 1.0
    # License: Copyright (c) [2023] CloudifyOps
    #          This file is licensed under the CloudifyOps.
    #
    ---
    apiVersion: v2
    type: application
    name: <custom_name_for_chart>
    version: <chart_version>
    appVersion: <app_verison>
    dependencies:
    - name: <custom_name_which_is_given_for_chart>
    repository: <Helm_repository_URL_of_the_component>
    version: <chart_version>


