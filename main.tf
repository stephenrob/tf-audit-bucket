provider "aws" {
    alias = "module"
    profile = "${var.aws_provider_profile}"
    region = "${var.aws_provider_region}"
    assume_role {
        role_arn = "${var.aws_provider_assume_role_arn}"
    }
}

resource "aws_s3_bucket" "audit" {
    provider = "aws.module"
    bucket = "${var.s3_audit_bucket_name}"
    acl = "${var.s3_audit_bucket_acl}"

    versioning = {
        enabled = "${var.s3_audit_bucket_versioning}"
    }

    tags {
        terraform = "true"
    }

    lifecycle_rule {
        id = "${var.s3_audit_bucket_lifecycle_id}"
        enabled = "${var.s3_audit_bucket_lifecycle_enabled}"

        prefix = "${var.s3_audit_log_prefix}"

        transition {
            days = "${var.s3_audit_bucket_transition_standard_ia}"
            storage_class = "STANDARD_IA"
        }

        noncurrent_version_transition {
            days = "${var.s3_audit_bucket_transition_non_current_standard_ia}"
            storage_class = "STANDARD_IA"
        }

        transition {
            days = "${var.s3_audit_bucket_transition_glacier}"
            storage_class = "GLACIER"
        }

        noncurrent_version_transition {
            days = "${var.s3_audit_bucket_transition_non_current_glacier}"
            storage_class = "GLACIER"
        }

        expiration {
            days = "${var.s3_audit_bucket_expiration}"
        }

        noncurrent_version_expiration {
            days = "${var.s3_audit_bucket_expiration_non_current}"
        }

    }
}

data "aws_iam_policy_document" "s3_audit_policy" {
    provider = "aws.module"
    statement {
        sid = "AWSCloudTrailAclCheck"
        principals {
            type = "Service"
            identifiers = ["cloudtrail.amazonaws.com"]
        }
        actions = [
            "s3:GetBucketAcl",
        ]
        resources = [
            "${aws_s3_bucket.audit.arn}",
        ]
    }
    statement {
        sid = "AWSCloudTrailWrite",
        principals {
            type = "Service"
            identifiers = ["cloudtrail.amazonaws.com"]
        }
        actions = [
            "s3:PutObject",
        ]
        resources = ["${formatlist("%s/AWSLogs/%s/*", aws_s3_bucket.audit.arn, var.ct_account_id_list)}"]
        condition = {
            test = "StringEquals"
            variable = "s3:x-amz-acl"
            values = ["bucket-owner-full-control"]
        }
    }
}
