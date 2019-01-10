# filter by prebacked ami
data "aws_ami" "amazon_optimized_amis" {
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
