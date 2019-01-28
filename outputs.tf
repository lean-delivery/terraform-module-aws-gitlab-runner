output "gitlab_runner_role" {
  value       = "${aws_iam_role.instance.name}"
  description = "Role for gitlabrunners"
}