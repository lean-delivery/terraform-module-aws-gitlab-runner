data "aws_ami" "amazon_optimized_amis" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "name"
    values = ["*gp2"]
  }
}
