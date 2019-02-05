################################################################################
### Main module
################################################################################
terraform {
  required_version = ">= 0.11.11"
}

provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_key_pair" "key" {
  key_name   = "${var.environment}-gitlab-runner"
  public_key = "${var.ssh_public_key}"
}

################################################################################
### Security groups
################################################################################
resource "aws_security_group" "runner" {
  name_prefix = "${var.environment}-security-group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${local.tags}"
}

resource "aws_security_group" "docker_machine" {
  name_prefix = "${var.environment}-docker-machine"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 2376
    to_port         = 2376
    protocol        = "tcp"
    security_groups = ["${aws_security_group.runner.id}"] # only from runner
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.runner.id}"] # only from runner
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${local.tags}"
}

################################################################################
### Trust policy
################################################################################
resource "aws_iam_instance_profile" "instance" {
  name = "${var.environment}-instance-profile"
  role = "${aws_iam_role.instance.name}"
}

data "template_file" "instance_role_trust_policy" {
  template = "${file("${path.module}/policies/instance-role-trust-policy.json")}"
}

resource "aws_iam_role" "instance" {
  name               = "${var.environment}-instance-role"
  assume_role_policy = "${data.template_file.instance_role_trust_policy.rendered}"
}

################################################################################
### docker machine instance policy
################################################################################
data "template_file" "docker_machine_policy" {
  template = "${file("${path.module}/policies/instance-docker-machine-policy.json")}"
}

resource "aws_iam_policy" "docker_machine" {
  name        = "${var.environment}-docker-machine"
  path        = "/"
  description = "Policy for docker machine."

  policy = "${data.template_file.docker_machine_policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "docker_machine" {
  role       = "${aws_iam_role.instance.name}"
  policy_arn = "${aws_iam_policy.docker_machine.arn}"
}

################################################################################
### Service linked policy, optional
################################################################################
data "template_file" "service_linked_role" {
  count = "${var.allow_iam_service_linked_role_creation ? 1 : 0}"

  template = "${file("${path.module}/policies/service-linked-role-create-policy.json")}"
}

resource "aws_iam_policy" "service_linked_role" {
  count = "${var.allow_iam_service_linked_role_creation ? 1 : 0}"

  name        = "${var.environment}-service_linked_role"
  path        = "/"
  description = "Policy for creation of service linked roles."

  policy = "${data.template_file.service_linked_role.rendered}"
}

resource "aws_iam_role_policy_attachment" "service_linked_role" {
  count = "${var.allow_iam_service_linked_role_creation ? 1 : 0}"

  role       = "${aws_iam_role.instance.name}"
  policy_arn = "${aws_iam_policy.service_linked_role.arn}"
}
