output "gitlab_runner_role" {
  value       = "${aws_iam_role.instance.name}"
  description = "Role for gitlabrunners"
}

output "gitlab_runner_security_group_id" {
  value       = "${aws_security_group.runner.id}"
  description = "Runner's security group ID"
}

output "gitlab_docker_machine_security_group_id" {
  value       = "${aws_security_group.docker_machine.id}"
  description = "Docker machine security group ID"
}
