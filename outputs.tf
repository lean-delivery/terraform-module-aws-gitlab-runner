output "gitlab_runner_role" {
  value       = "${aws_iam_role.instance.name}"
  description = "Role for gitlabrunners"
}

output "iam_bucket_role" {
  value       = "${aws_iam_role.iam_bucket.name}"
  description = "Role for gitlabrunners"
}
