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