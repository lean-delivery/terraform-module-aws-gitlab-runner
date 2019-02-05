variable "availability_zone_runners" {
  description = "Availability zone used to host the docker-machine runners."
  type        = "string"
  default     = "a"
}

variable "aws_region" {
  description = "AWS region."
  type        = "string"
}

variable "cache_user" {
  description = "User name of the user to create to write and read to the s3 cache."
  type        = "string"
  default     = "cache_user"
}

variable "cache_expiration_days" {
  description = "Number of days before cache objects expires."
  default     = 1
}

variable "docker_machine_instance_type" {
  description = "Instance type used for the instances hosting docker-machine."
  default     = "m4.xlarge"
}

variable "docker_machine_spot_price_bid" {
  description = "Spot price bid."
  default     = "0.1"
}

variable "docker_machine_user" {
  description = "User name for the user to create spot instances to host docker-machine."
  type        = "string"
  default     = "docker-machine"
}

variable "docker_machine_version" {
  description = "Version of docker-machine."
  default     = "0.15.0"
}

variable "enable_cloudwatch_logging" {
  description = "Enable or disable the CloudWatch logging."
  default     = 1
}

variable "environment" {
  description = "A name that identifies the environment, will used as prefix and for tagging."
  type        = "string"
}

variable "gitlab_runner_version" {
  description = "Version for the gitlab runner."
  type        = "string"
  default     = "11.3.1"
}

variable "instance_type" {
  description = "Instance type used for the gitlab-runner."
  type        = "string"
  default     = "t2.micro"
}

variable "runners_gitlab_url" {
  description = "URL of the gitlab instance to connect to."
  type        = "string"
}

variable "runners_token" {
  description = "Token for the runner, will be used in the runner config.toml"
  type        = "string"
}

variable "runners_limit" {
  description = "Limit for the runners, will be used in the runner config.toml"
  default     = 0
}

variable "runners_concurrent" {
  description = "Concurrent value for the runners, will be used in the runner config.toml"
  default     = 10
}

variable "runners_idle_time" {
  description = "Idle time of the runners, will be used in the runner config.toml"
  default     = 600
}

variable "runners_idle_count" {
  description = "Idle count of the runners, will be used in the runner config.toml"
  default     = 0
}

variable "runners_privilled" {
  description = "Runners will run in privilled mode, will be used in the runner config.toml"
  type        = "string"
  default     = "true"
}

variable "runners_monitoring" {
  description = "Enable detailed cloudwatch monitoring for spot instances."
  default     = false
}

variable "runners_name" {
  description = "Name of the runner, will be used in the runner config.toml"
  type        = "string"
}

variable "runners_off_peak_timezone" {
  description = "Off peak idle time zone of the runners, will be used in the runner config.toml."
  default     = ""
}

variable "runners_off_peak_idle_count" {
  description = "Off peak idle count of the runners, will be used in the runner config.toml."
  default     = 0
}

variable "runners_off_peak_idle_time" {
  description = "Off peak idle time of the runners, will be used in the runner config.toml."
  default     = 0
}

variable "runners_off_peak_periods" {
  description = "Off peak periods of the runners, will be used in the runner config.toml."
  type        = "string"
  default     = "* * * * * sat,sun *"
}

variable "runners_root_size" {
  description = "Runnner instance root size in GB."
  default     = 16
}

variable "runners_use_private_address" {
  description = "Restrict runners to use only private address"
  default     = "true"
}

variable "ssh_public_key" {
  description = "Public SSH key used for the gitlab-runner ec2 instance."
  type        = "string"
}

variable "subnet_id_gitlab_runner" {
  description = "Subnet used for hosting the gitlab-runner."
  type        = "string"
}

variable "subnet_id_runners" {
  description = "Subnet used to hosts the docker-machine runners."
  type        = "string"
}

variable "tags" {
  type        = "map"
  description = "Map of tags that will be added to created resources. By default resources will be taggen with name and environemnt."
  default     = {}
}

variable "vpc_id" {
  description = "The VPC that is used for the instances."
  type        = "string"
}

variable "availability_zone_proxy" {
  description = "Availability zone used to host the proxy."
  type        = "string"
  default     = "a"
}

variable "custom_ami_filter" {
  description = "Name of the prebaked ami with gitlab runner proxy preinstalled"
  type        = "string"
  default     = ""
}

variable "allow_iam_service_linked_role_creation" {
  description = "Attach policy to runner instance to create service linked roles."
  default     = true
}

variable "use_prebacked_ami" {
  description = "Use prebacked ami for runner by default"
  default     = 0
}

variable "bastion_ip" {
  description = "IP of Bastion instance"
  type        = "string"
}
