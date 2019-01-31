data "template_file" "user_data" {
  template = "${file("${path.module}/template/user-data.tpl")}"

  vars {
    logging       = "${var.enable_cloudwatch_logging ? data.template_file.logging.rendered : ""}"
    gitlab_runner = "${data.template_file.gitlab_runner.rendered}"
  }
}

data "template_file" "logging" {
  template = "${file("${path.module}/template/logging.tpl")}"

  vars {
    environment = "${var.environment}"
  }
}

data "template_file" "runners" {
  template = "${file("${path.module}/template/runner-config.tpl")}"

  vars {
    runners_concurrent = "${var.runners_concurrent}"
  }
}

data "template_file" "gitlab_runner" {
  template = "${file("${path.module}/template/gitlab-runner.tpl")}"

  vars {
    gitlab_runner_version  = "${var.gitlab_runner_version}"
    docker_machine_version = "${var.docker_machine_version}"

    aws_region  = "${var.aws_region}"
    gitlab_url  = "${var.runners_gitlab_url}"
    environment = "${var.environment}"

    runners_vpc_id              = "${var.vpc_id}"
    runners_subnet_id           = "${var.subnet_id_runners}"
    runners_availability_zone   = "${var.availability_zone_runners}"
    runners_instance_type       = "${var.docker_machine_instance_type}"
    runners_spot_price_bid      = "${var.docker_machine_spot_price_bid}"
    runners_security_group_name = "${aws_security_group.docker_machine.name}"
    runners_monitoring          = "${var.runners_monitoring}"
    runners_name                = "${var.runners_name}"
    runners_token               = "${var.runners_token}"
    runners_limit               = "${var.runners_limit}"
    runners_concurrent          = "${var.runners_concurrent}"
    runners_privilled           = "${var.runners_privilled}"
    runners_idle_count          = "${var.runners_idle_count}"
    runners_idle_time           = "${var.runners_idle_time}"
    runners_off_peak_timezone   = "${var.runners_off_peak_timezone}"
    runners_off_peak_idle_count = "${var.runners_off_peak_idle_count}"
    runners_off_peak_idle_time  = "${var.runners_off_peak_idle_time}"
    runners_off_peak_periods    = "${var.runners_off_peak_periods}"
    runners_root_size           = "${var.runners_root_size}"
    runners_use_private_address = "${var.runners_use_private_address}"
    bucket_iam_instance_profile = "${aws_iam_instance_profile.iam_bucket.name}"
    bucket_name                 = "${aws_s3_bucket.build_cache.bucket}"
    runner_environment_tag = "${var.environment}"

    runners_config = "${data.template_file.runners.rendered}"
  }
}


# filter amazon ami
data "aws_ami" "amazon_optimized_amis" {
  count  = "${var.use_prebacked_ami ? 0 : 1}"
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-2018.*"] 
  }

  filter {
    name   = "name"
    values = ["*gp2"]
  }
}

# create ec2 resourse 
resource "aws_instance" "gitlab-runner-userdata" {
  count  = "${var.use_prebacked_ami ? 0 : 1}"
  ami                         = "${data.aws_ami.amazon_optimized_amis.id}"
  instance_type               = "${var.instance_type}"
  monitoring                  = false
  subnet_id                   = "${var.subnet_id_gitlab_runner}"
  user_data                   = "${data.template_file.user_data.rendered}"
  vpc_security_group_ids      = ["${aws_security_group.runner.id}"]
  associate_public_ip_address = false
  iam_instance_profile = "${aws_iam_instance_profile.instance.name}"

  tags = "${local.tags}"
}