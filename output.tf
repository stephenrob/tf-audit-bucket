output "bucket_id" {
  value = "${aws_s3_bucket.audit.id}"
}

output "bucket_arn" {
  value = "${aws_s3_bucket.audit.arn}"
}

output "bucket_policy_json" {
    value = "${data.aws_iam_policy_document.s3_audit_policy.json}"
}