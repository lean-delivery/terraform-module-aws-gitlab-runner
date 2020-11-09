################################################################################
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "build_cache" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.environment}-gitlab-cache"
  acl    = "private"

  tags = local.tags

  force_destroy = true

  versioning {
    enabled = false
  }

  lifecycle_rule {
    id      = "clear"
    enabled = true

    prefix = "runner/"

    expiration {
      days = var.cache_expiration_days
    }
  }
}

data "aws_iam_policy_document" "bucket-policy-doc" {
  statement {
    actions = [
      "s3:*",
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.instance.arn]
    }

    resources = [
      "${aws_s3_bucket.build_cache.arn}/*",
      aws_s3_bucket.build_cache.arn,
    ]
  }
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.build_cache.id
  policy = data.aws_iam_policy_document.bucket-policy-doc.json
}
