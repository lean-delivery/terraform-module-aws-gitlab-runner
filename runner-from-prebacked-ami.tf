# filter by prebacked ami
data "aws_ami" "custom_ami" {
  count       = "${var.use_prebacked_ami ? 1 : 0}"
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["${var.custom_ami_filter}*"]
  }
}

# create ec2 resourse
resource "aws_instance" "gitlab-runner-prebacked" {
  count                       = "${var.use_prebacked_ami && !var.use_public_key ? 1 : 0}"
  ami                         = "${data.aws_ami.custom_ami.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.key.key_name}"
  monitoring                  = false
  subnet_id                   = "${var.subnet_id_gitlab_runner}"
  vpc_security_group_ids      = ["${aws_security_group.runner.id}"]
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.instance.name}"

  tags = "${local.tags}"
}

resource "aws_instance" "gitlab-runner-prebacked-key" {
  count                       = "${var.use_prebacked_ami && var.use_public_key ? 1 : 0}"
  ami                         = "${data.aws_ami.custom_ami.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.key.key_name}"
  monitoring                  = false
  subnet_id                   = "${var.subnet_id_gitlab_runner}"
  vpc_security_group_ids      = ["${aws_security_group.runner.id}"]
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.instance.name}"

  tags = "${local.tags}"
}
