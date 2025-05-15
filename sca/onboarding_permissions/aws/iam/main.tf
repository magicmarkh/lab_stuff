provider "aws" {
  region = var.region
}

# Create the IAM policy
resource "aws_iam_policy" "cyberark_sca_full" {
  name        = "CyberArkSCAFullPermissions"
  description = "Complete permissions for CyberArk SCA onboarding, admin, and account management tasks"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          # CloudFormation Management
          "cloudformation:CreateStack",
          "cloudformation:CreateStackInstances",
          "cloudformation:DeleteStack",
          "cloudformation:DeleteStackInstances",
          "cloudformation:DeleteStackSet",
          "cloudformation:DescribeStackEvents",
          "cloudformation:DescribeStacks",
          "cloudformation:DescribeStackSet",
          "cloudformation:DescribeStackSetOperation",
          "cloudformation:GetTemplateSummary",
          "cloudformation:ListStacks",
          "cloudformation:TagResource",

          # EventBridge / CloudWatch Events
          "events:DescribeRule",
          "events:PutRule",
          "events:PutTargets",
          "events:RemoveTargets",

          # IAM Admin and Read
          "iam:AttachRolePolicy",
          "iam:CreateRole",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:PassRole",
          "iam:PutRolePolicy",
          "iam:GenerateCredentialReport",
          "iam:GetAccountAuthorizationDetails",
          "iam:GetCredentialReport",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListAttachedRolePolicies",
          "iam:ListMFADevices",
          "iam:ListRolePolicies",
          "iam:ListRoles",
          "iam:ListVirtualMFADevices",
          "iam:DeleteRole",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",

          # S3 Management and Replication
          "s3:BypassGovernanceRetention",
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:DeleteBucketPolicy",
          "s3:DeleteObject",
          "s3:DeleteObjectTagging",
          "s3:DeleteObjectVersion",
          "s3:DeleteObjectVersionTagging",
          "s3:GetBucketPolicy",
          "s3:GetObject",
          "s3:GetObjectLegalHold",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectVersionTorrent",
          "s3:ListAllMyBuckets",
          "s3:ListBuckets",
          "s3:ListBucketVersions",
          "s3:ListMultipartUploadParts",
          "s3:ObjectOwnerOverrideToBucketOwner",
          "s3:PutBucketPolicy",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutEncryptionConfiguration",
          "s3:PutLifecycleConfiguration",
          "s3:PutObjectLegalHold",
          "s3:PutObjectRetention",
          "s3:PutObjectVersionAcl",
          "s3:PutObjectVersionTagging",
          "s3:ReplicateDelete",
          "s3:ReplicateObject",
          "s3:ReplicateTags",

          # SNS
          "sns:Publish"
        ],
        Resource = "*"
      }
    ]
  })
}

# Create the IAM role
resource "aws_iam_role" "cyberark_sca_admin_role" {
  name = "CyberArk_SCA_Admin_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_cyberark_sca_policy" {
  role       = aws_iam_role.cyberark_sca_admin_role.name
  policy_arn = aws_iam_policy.cyberark_sca_full.arn
}
