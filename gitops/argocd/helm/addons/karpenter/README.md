# Karpenter

Karpenter is an open-source node provisioning project built for Kubernetes. Adding Karpenter to a Kubernetes cluster can dramatically improve the efficiency and cost of running workloads on that cluster.

### Pre-requisites

* Two IAM roles needs to be created - one for the nodes provisioned with Karpenter and the other for Karpenter controller.
* Tags for nodegroup subnets and security groups.
* Update aws-auth ConfigMap 

#### Node role

1) Create the Karpenter node role with the below policy.
- Note: You must create the node role name with the cluster name at the end. For example: "KarpenterNodeRole-<cluster_name>"
```shell
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

2) Attach the following policies to the above role.
```shell
- AmazonEKSWorkerNodePolicy
- AmazonEKS_CNI_Policy
- AmazonEC2ContainerRegistryReadOnly
- AmazonSSMManagedInstanceCore
```

3) Attach the IAM role to an EC2 instance profile.

```shell
aws iam create-instance-profile \
    --instance-profile-name "<instace_profile_name>"

aws iam add-role-to-instance-profile \
    --instance-profile-name "<instance_profile_name>" \
    --role-name "<node_role_name>"
```

#### Karpenter Controller Role

The controller will be using IAM Roles for Service Accounts (IRSA) which requires an OIDC endpoint.

1) Create an IAM Role with the following trust policy.
- Note: You must create the controller role name with the cluster name at the end. For example: "KarpenterControllerRole-<cluster_name>"
```shell
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/${OIDC_ENDPOINT#*//}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "${OIDC_ENDPOINT#*//}:aud": "sts.amazonaws.com",
                    "${OIDC_ENDPOINT#*//}:sub": "system:serviceaccount:karpenter:karpenter"
                }
            }
        }
    ]
}
```

2) Attach the following policy to the above controller IAM role.
```shell
{
    "Statement": [
        {
            "Action": [
                "ssm:GetParameter",
                "ec2:DescribeImages",
                "ec2:RunInstances",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeInstanceTypeOfferings",
                "ec2:DescribeAvailabilityZones",
                "ec2:DeleteLaunchTemplate",
                "ec2:CreateTags",
                "ec2:CreateLaunchTemplate",
                "ec2:CreateFleet",
                "ec2:DescribeSpotPriceHistory",
                "pricing:GetProducts"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "Karpenter"
        },
        {
            "Action": "ec2:TerminateInstances",
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/Name": "*karpenter*"
                }
            },
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "ConditionalEC2Termination"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:role/<Name of the KarpenterNodeRole>",
            "Sid": "PassNodeIAMRole"
        },
        {
            "Effect": "Allow",
            "Action": "eks:DescribeCluster",
            "Resource": "arn:${AWS_PARTITION}:eks:${AWS_REGION}:${AWS_ACCOUNT_ID}:cluster/${CLUSTER_NAME}",
            "Sid": "EKSClusterEndpointLookup"
        }
    ],
    "Version": "2012-10-17"
}
```

#### Add tags to Subnets and Security Groups

Tags need to be added to our nodegroup subnets so Karpenter will know which subnets to use.

The Subnets and the Security Groups need to have the following tag to be discovered by Karpenter.
```shell
Key=karpenter.sh/discovery,Value=${CLUSTER_NAME}
```

#### Update aws-auth ConfigMap

We need to allow nodes that are using the node IAM role we just created to join the cluster. To do that we have to modify the aws-auth ConfigMap in the cluster.

```shell
kubectl edit configmap aws-auth -n kube-system
```

Add the following group under mapRules section:
```shell
- groups:
  - system:bootstrappers
  - system:nodes
  rolearn: arn:aws:iam::${AWS_ACCOUNT_ID}:role/<Name of the KarpenterNodeRole>
  username: system:node:{{EC2PrivateDNSName}}
```

#### Reference
* [Installing karpenter on AWS EKS](https://repost.aws/knowledge-center/eks-install-karpenter)
