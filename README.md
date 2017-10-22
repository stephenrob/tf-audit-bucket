# TF - AWS Cloudtrail Audit Bucket
Terraform module for defining an AWS S3 bucket with bucket policy and lifecycle rules for storing CloudTrail Audit logs.

## Using the module

```[hcl]
module "aws_audit_bucket" {
    source = "github.com/stephenrob/tf-audit-bucket"

    aws_provider_profile = "myproviderprofule"
    aws_provider_region = "eu-west-1"
    aws_provider_assume_role_arn = "arn:aws:iam::111111111111:role/AccountAccessRole"

    s3_audit_bucket_name = "mybucketname"
    s3_audit_bucket_acl = "private"
    s3_audit_bucket_versioning = true
    s3_audit_log_prefix = "AWSLogs/"
    s3_audit_bucket_lifecycle_id = "aws-logs"
    s3_audit_bucket_lifecycle_enabled = true
    s3_audit_bucket_transition_standard_ia = 30
    s3_audit_bucket_transition_non_current_standard_ia = 30
    s3_audit_bucket_transition_glacier = 90
    s3_audit_bucket_transition_non_current_glacier = 60
    s3_audit_bucket_expiration = 455
    s3_audit_bucket_expiration_non_current = 455
    ct_account_id_list = "[111111111111,222222222222,333333333333]"
}
```

## Input Variables

| Variable | Default | Description |
| --- | --- | --- |
| aws_provider_profile | default | Profile to use from the aws credentials file |
| aws_provider_region | N/A | Region to initialise the provider in |
| aws_provider_assume_role_arn | `Empty String` | ARN of the role to assume for the specified provider |
| s3_audit_bucket_name | N/A | Name/ID to give the S3 audit bucket that will be created |
| s3_audit_bucket_acl | private | ACL of the S3 audit bucket |
| s3_audit_bucket_versioning | true | Enable versioning on the S3 audit bucket |
| s3_audit_bucket_log_prefix | AWSLogs/ | Prefix on which to apply the S3 audit bucket lifecycle rules. |
| s3_audit_bucket_lifecycle_id | aws-logs | ID for the lifecycle rule of the audit bucket |
| s3_audit_bucket_lifecycle_enabled | true | Enable the lifecycle rules on the audit bucket |
| s3_audit_bucket_transition_standard_ia | 30 | Number of days after current version of log files have been created until they are transfered to standard infrequent access tier |
| s3_audit_bucket_transition_non_current_standard_ia | 30 | Number of days after non current version of log files have been created until they are transfered to standard infrequent access tier |
| s3_audit_bucket_transition_glacier| 90 | Number of days after current version of log files have been created until they are transfered to glacier tier |
| s3_audit_bucket_transition_non_current_glacier | 60 | Number of days after non current version of log files have been created until they are transfered to glacier tier |
| s3_audit_bucket_expiration | 455 | Number of days after current version of log files have been created until they are expired and deleted |
| s3_audit_bucket_expiration_non_current | 455 | Number of days after non current version of log files have been created until they are expired and deleted |
| ct_account_id_list | N/A | List of account id's to allow writing their CloudTrails to this audit bucket |

## Outputs

| Variable | Description |
| --- | --- |
| bucket_id | ID of the S3 audit bucket |
| bucket_arn | ARN of the S3 audit bucket |
