## Velero
- [Velero](https://aws.amazon.com/blogs/containers/backup-and-restore-your-amazon-eks-cluster-resources-using-velero/) is an open-source backup and recovery tool for Kubernetes.
- It provides a simple and reliable way to backup and restore Kubernetes resources and persistent volumes.
- With Valero, you can create backups of your Kubernetes cluster resources, including namespaces, deployments, services, and config maps, as well as persistent volumes that are associated with them. 
- These backups can be stored in different locations, such as cloud storage or on-premise storage, for disaster recovery purposes.

##### Prerequisites

- Create the IAM policy for Velero with below permmisions
```
					
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET}"
            ]
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
                "Federated": "arn:aws:iam::<Account ID>:oidc-provider/oidc.<Region name>.amazonaws.com/id/<oidc URL>"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.<Region name>.amazonaws.com/id/<oidc url>:sub": "system:serviceaccount:velero:<service account name>",
                    "oidc.<region name>.amazonaws.com/id/<oidc url>:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
}
```
- Create an S3 bucket to store the backups and add the bucket policy as shown below

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<Account ID>:role/<Role name>"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::<Bucket name>"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<Account ID>:role/<Role Name>"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::<Bucket name>/*"
        }
    ]
}
```

#### Reference
[Velero](https://github.com/vmware-tanzu/velero)



