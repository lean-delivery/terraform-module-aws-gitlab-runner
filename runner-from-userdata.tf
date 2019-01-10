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
    bucket_user_access_key      = "${aws_iam_access_key.cache_user.id}"
    bucket_user_secret_key      = "${aws_iam_access_key.cache_user.secret}"
    bucket_name                 = "${aws_s3_bucket.build_cache.bucket}"

    runners_config = "${data.template_file.runners.rendered}"
  }
}


# filter amazon ami

# create ec2 resourse 
