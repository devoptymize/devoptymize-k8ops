# AWS SECRET-STORE-CSI-DRIVER

   AWS Secret Store CSI Driver is a container storage interface (CSI) driver that enables you to retrieve secrets from AWS Secrets Manager or AWS Systems Manager Parameter Store and inject them directly into your containerized applications running on Amazon Elastic Kubernetes Service (EKS) or self-managed Kubernetes clusters. The AWS provider for the Secrets Store CSI Driver allows you to make secrets stored in Secrets Manager and parameters stored in Parameter Store appear as files mounted in Kubernetes pods.

## Prerequisites

This solution has the following prerequisites:

- An AWS account.
- An IAM policy with permissions to retrieve a secret from Secrets Manager.
- create a permissions policy that grants ```secretsmanager:GetSecretValue``` and ```secretsmanager:DescribeSecret``` permission to the secrets that the pod needs to access.
- create a trust policy for the role that allow action ```sts:AssumeRoleWithWebIdentity```
- Your secret stored in Secrets Manager
- An existing EKS Cluster
- A user that can modify your Kubernetes cluster
- AWS CLI and kubectl installed
- Helm and eksctl installed

## Reference

- [Aws-secret-store-csi-driver](https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver.html)
