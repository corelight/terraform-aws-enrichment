locals {
  bucket_name             = "corelight-enrichment"
  enrichment_ecr_repo_arn = "arn:aws:ecr:us-east-1:12345:repository/aws-cloud-enrichment"
  image_name              = "12345.dkr.ecr.us-east-1.amazonaws.com/aws-cloud-enrichment"
  image_tag               = "1.0.0"
  secondary_rule_name     = "corelight-ec2-state-change"
  regions_used            = [
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2"
  ]

  tags = {
    terraform : true,
    example : true,
    purpose : Corelight
  }
}

provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

resource "aws_s3_bucket" "enrichment_bucket" {
  provider = aws.primary

  bucket = local.bucket_name

  tags = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "enrichment_bucket_encryption" {
  provider = aws.primary

  bucket = aws_s3_bucket.enrichment_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

module "enrichment_iam" {
  source = "../../modules/iam"

  providers = {
    "aws" = aws.primary
  }

  cloudwatch_log_group_arn = module.enrichment_main.cloudwatch_log_group_arn
  ecr_repository_arn       = local.enrichment_ecr_repo_arn
  enrichment_bucket_arn    = aws_s3_bucket.enrichment_bucket.arn
  primary_bus_arn          = module.enrichment_main.primary_event_bus_arn

  tags = local.tags
}

module "enrichment_main" {
  source = "../../modules/enrichment"

  providers = {
    "aws" = aws.primary
  }

  corelight_cloud_enrichment_image     = local.image_name
  corelight_cloud_enrichment_image_tag = local.image_tag
  cross_region_role_arn                = module.enrichment_iam.eventbridge_role_arn
  enrichment_bucket_name               = aws_s3_bucket.enrichment_bucket.bucket
  enrichment_bucket_region             = aws_s3_bucket.enrichment_bucket.region
  lambda_iam_role_arn                  = module.enrichment_iam.lambda_role_arn

  tags = local.tags
}


# Secondary Regions
provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}


module "secondary_eventbridge_rule_us-east-2" {
  source = "../../modules/secondary_event_rule"

  providers = {
    aws = aws.us-east-2
  }

  cross_region_iam_role_arn            = module.enrichment_iam.eventbridge_role_arn
  primary_event_bus_arn                = module.enrichment_main.primary_event_bus_arn
  secondary_ec2_state_change_rule_name = "${local.secondary_rule_name}-us-east-2"

  tags = local.tags
}

provider "aws" {
  alias  = "us-west-1"
  region = "us-west-2"
}

module "secondary_eventbridge_rule_us-west-1" {
  source = "../../modules/secondary_event_rule"

  providers = {
    aws = aws.us-west-1
  }

  cross_region_iam_role_arn            = module.enrichment_iam.eventbridge_role_arn
  primary_event_bus_arn                = module.enrichment_main.primary_event_bus_arn
  secondary_ec2_state_change_rule_name = "${local.secondary_rule_name}-us-west-1"

  tags = local.tags
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

module "secondary_eventbridge_rule_us-west-2" {
  source = "../../modules/secondary_event_rule"

  providers = {
    aws = aws.us-west-2
  }

  cross_region_iam_role_arn            = module.enrichment_iam.eventbridge_role_arn
  primary_event_bus_arn                = module.enrichment_main.primary_event_bus_arn
  secondary_ec2_state_change_rule_name = "${local.secondary_rule_name}-us-west-2"

  tags = local.tags
}