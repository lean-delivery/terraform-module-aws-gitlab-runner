data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "build_cache" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.environment}-cache"
  acl    = "private"

  tags = "${local.tags}"

  force_destroy = true

  versioning {
    enabled = false
  }

  lifecycle_rule {
    id      = "clear"
    enabled = true

    prefix = "runner/"

    expiration {
      days = "${var.cache_expiration_days}"
    }
  }
}
# Why separate user? - Because we use its credentials on gitlab-workers for accessing cache and nothing more than that
resource "aws_iam_instance_profile" "iam_bucket" {
  name = "${var.environment}-iam_bucket-profile"
  role = "${aws_iam_role.iam_bucket.name}"
}

data "template_file" "instance_role_s3_policy" {
  template = "${file("${path.module}/policies/instance-s3-policy.json")}"
}

resource "aws_iam_policy" "instance_role_s3_policy" {
  name        = "${var.environment}-instance_role_s3_policy"
  path        = "/"
  description = "Policy for docker machine."

  policy = "${data.template_file.instance_role_s3_policy.rendered}"
}

data "aws_iam_policy_document" "iam-bucket-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_bucket" {
  name               = "${var.environment}-iam_bucket-role"
  assume_role_policy = "${data.aws_iam_policy_document.iam-bucket-role-policy.json}"
}

resource "aws_iam_role_policy_attachment" "iam_bucket" {
  role       = "${aws_iam_role.iam_bucket.name}"
  policy_arn = "${aws_iam_policy.instance_role_s3_policy.arn}"
}

data "aws_iam_policy_document" "bucket-policy-doc" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:GetObjectAcl",
    ]

    principals = {
      type        = "AWS"
      identifiers = ["${aws_iam_role.iam_bucket.arn}"]
    }

    resources = [
      "${aws_s3_bucket.build_cache.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = "${aws_s3_bucket.build_cache.id}"
  policy = "${data.aws_iam_policy_document.bucket-policy-doc.json}"
}
