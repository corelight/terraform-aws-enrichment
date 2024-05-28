data "aws_s3_bucket" "enrichment_bucket" {
  bucket = var.enrichment_bucket_name
}

data "aws_ecr_repository" "enrichment_repo" {
  name = split("/", var.corelight_cloud_enrichment_image)[1]
}