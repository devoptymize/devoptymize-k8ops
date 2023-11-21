## EFS-CSI Driver
The [EFS-CSI Driver](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html) refers to the Container Storage Interface (CSI) driver for Amazon Elastic File System (EFS).

Amazon EFS is a cloud-based file storage service that allows you to create, scale and manage the file systems which an be accessed from multiple AWS instances simultaneously.

The CSI driver enables Kubernetes users to use Amazon EFS as a persistent storage option for their applications running on Kubernetes cluster. 

### Prerequisites

- Create the IAM policy for EFS csi Driver with below permmisions

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:DescribeAccessPoints",
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:DescribeMountTargets",
        "ec2:DescribeAvailabilityZones"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:CreateAccessPoint"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:RequestTag/efs.csi.aws.com/cluster": "true"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:TagResource"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "elasticfilesystem:DeleteAccessPoint",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
        }
      }
    }
  ]
}
```
- Attach the IAM policy to the IAM role created and add the trust policy as given below
- Update the Trust policy with the Account ID, Region name and OpenID Connect provider URL
- Ensure to add the IAM role's arn as annotation for service account in the values.yaml

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<Account ID>:oidc-provider/oidc.<eks.region-code>.amazonaws.com/id/<oidc value>"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.<eks.region-code>.amazonaws.com/id/<oidc value>:sub": "system:serviceaccount:kube-system:<Sevice Account name>"
        }
      }
    }
  ]
}
```
- Reference:
https://github.com/kubernetes-sigs/aws-efs-csi-driver
