locals {
  bucket_name             = "corelight-enrichment"
  enrichment_ecr_repo_arn = "arn:aws:ecr:us-east-1:12345:repository/sensor-enrichment-aws"
  image_name              = "12345.dkr.ecr.us-east-1.amazonaws.com/sensor-enrichment-aws"
  image_tag               = "latest"
  secondary_rule_name     = "corelight-ec2-state-change"
  my_regions = [
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2"
  ]

  tags = {
    terraform : true,
    example : true,
    purpose : "Corelight"
  }
}


####################################################################################################
# Create the bucket where all enrichment data will be stored
####################################################################################################
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

####################################################################################################
# Deploy the lambda and supporting resources for the primary region
# Replace relative source with "source = github.com/corelight/terraform-aws-enrichment"
####################################################################################################
module "enrichment" {
  source = "../.."

  providers = {
    aws = aws.primary
  }

  corelight_cloud_enrichment_image     = local.image_name
  corelight_cloud_enrichment_image_tag = local.image_tag
  enrichment_bucket_name               = aws_s3_bucket.enrichment_bucket.bucket
  enrichment_bucket_region             = aws_s3_bucket.enrichment_bucket.region
  enrichment_bucket_arn                = aws_s3_bucket.enrichment_bucket.arn
  ecr_repository_arn                   = local.enrichment_ecr_repo_arn
  scheduled_sync_regions               = local.my_regions

  tags = local.tags
}

####################################################################################################
# Assign Corelight sensor auto-scale group permission to read from the bucket
####################################################################################################

module "sensor_iam" {
  source = "../../modules/sensor_iam"

  enrichment_bucket_arn = aws_s3_bucket.enrichment_bucket.arn

  tags = local.tags
}

resource "aws_iam_instance_profile" "corelight_sensor" {
  name = "corelight-sensor-profile"
  role = module.sensor_iam.sensor_role_arn

  tags = local.tags
}


####################################################################################################
# Setup providers and deploy the "Fan In" event bus resources in each secondary region
####################################################################################################

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}


module "secondary_eventbridge_rule_us-east-2" {
  source = "../../modules/secondary_event_rule"

  providers = {
    aws = aws.us-east-2
  }

  cross_region_eventbridge_role_arn    = module.enrichment.cross_region_iam_role_arn
  primary_event_bus_arn                = module.enrichment.primary_event_bus_arn
  secondary_ec2_state_change_rule_name = "${local.secondary_rule_name}-us-east-2"

  tags = local.tags
}

provider "aws" {
  alias  = "us-west-1"
  region = "us-west-1"
}

module "secondary_eventbridge_rule_us-west-1" {
  source = "../../modules/secondary_event_rule"

  providers = {
    aws = aws.us-west-1
  }

  cross_region_eventbridge_role_arn    = module.enrichment.cross_region_iam_role_arn
  primary_event_bus_arn                = module.enrichment.primary_event_bus_arn
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

  cross_region_eventbridge_role_arn    = module.enrichment.cross_region_iam_role_arn
  primary_event_bus_arn                = module.enrichment.primary_event_bus_arn
  secondary_ec2_state_change_rule_name = "${local.secondary_rule_name}-us-west-2"

  tags = local.tags
}