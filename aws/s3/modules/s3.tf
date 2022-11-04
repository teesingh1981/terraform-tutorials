resource "aws_s3_bucket" "s3_bucket" {
    name = var.s3_bucket_name
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
    bucket = aws_s3_bucket.s3_bucket
    acl = "private"
}