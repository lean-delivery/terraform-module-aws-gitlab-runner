################################################################################
locals {
  tags = merge(
    {
      "Name" = format("%s", var.environment)
    },
    {
      "Environment" = format("%s", var.environment)
    },
    var.tags,
  )
}

data "null_data_source" "tags" {
  count = length(local.tags)

  inputs = {
    key                 = element(keys(local.tags), count.index)
    value               = element(values(local.tags), count.index)
    propagate_at_launch = "true"
  }
}

