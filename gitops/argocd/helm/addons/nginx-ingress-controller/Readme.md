# Nginx-Ingress-Controller

The Nginx Ingress Controller is a popular open-source software solution for managing ingress traffic in Kubernetes environments. It is designed to provide load balancing, SSL termination, and other advanced traffic management features for Kubernetes clusters. With Nginx Ingress Controller, you can define rules for routing incoming traffic to the appropriate services in your Kubernetes cluster. This allows you to expose your services to the internet and provides users with access to your application.

## Prerequisites

This solution has the following prerequisites:

- An AWS account.
- Create the IAM policy with below permissions
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ec2:DescribeInstances",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeSubnets",
              "ec2:DescribeTags",
              "ec2:DescribeVpcs",
              "elasticloadbalancing:AddTags",
              "elasticloadbalancing:CreateListener",
              "elasticloadbalancing:CreateLoadBalancer",
              "elasticloadbalancing:CreateRule",
              "elasticloadbalancing:CreateTargetGroup",
              "elasticloadbalancing:DeleteListener",
              "elasticloadbalancing:DeleteLoadBalancer",
              "elasticloadbalancing:DeleteRule",
              "elasticloadbalancing:DeleteTargetGroup",
              "elasticloadbalancing:DeregisterTargets",
              "elasticloadbalancing:DescribeListeners",
              "elasticloadbalancing:DescribeLoadBalancers",
              "elasticloadbalancing:DescribeRules",
              "elasticloadbalancing:DescribeTargetGroups",
              "elasticloadbalancing:DescribeTargetHealth",
              "elasticloadbalancing:RegisterTargets",
              "elasticloadbalancing:SetSecurityGroups",
              "elasticloadbalancing:SetSubnets",
              "iam:CreateServiceLinkedRole",
              "iam:GetServerCertificate",
              "iam:ListServerCertificates",
              "waf-regional:GetWebACLForResource",
              "waf-regional:GetWebACL",
              "waf-regional:AssociateWebACL",
              "waf-regional:DisassociateWebACL"
            ],
            "Resource": "*"
        }
    ]
}
```
- Attach the policy created above to the role.


## Reference:
[nginx-ingress-controller](https://artifacthub.io/packages/helm/bitnami/nginx-ingress-controller/9.4.1)
