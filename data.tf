data "aws_s3_bucket" "enrichment_bucket" {
  bucket = var.enrichment_bucket_name
}