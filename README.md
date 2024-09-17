# terraform-aws-enrichment

<img src="docs/overview.svg" alt="overview">

## Usage

```terraform
resource "aws_s3_bucket" "enrichment_bucket" {
  bucket = "corelight-enrichment"
}

module "enrichment_eventbridge_role" {
  source = "github.com/corelight/terraform-aws-enrichment//modules/iam/eventbridge"

  primary_event_bus_arn = module.enrichment.primary_event_bus_arn
}

module "enrichment_lambda_role" {
  source = "github.com/corelight/terraform-aws-enrichment//modules/iam/lambda"

  enrichment_bucket_arn           = aws_s3_bucket.enrichment_bucket.arn
  enrichment_ecr_repository_arn   = data.aws_ecr_repository.enrichment_repo.arn
  lambda_cloudwatch_log_group_arn = module.enrichment.cloudwatch_log_group_arn
}

module "enrichment" {
  source = "github.com/corelight/terraform-aws-enrichment"

  corelight_cloud_enrichment_image = "123456789111.dkr.ecr.us-east-1.amazonaws.com/corelight-sensor-enrichment-aws"
  corelight_cloud_enrichment_image_tag = "0.1.0"
  enrichment_bucket_name = aws_s3_bucket.enrichment_bucket.bucket
  eventbridge_iam_cross_region_role_arn = module.enrichment_eventbridge_role.cross_region_role_arn
  lambda_iam_role_arn                   = module.enrichment_lambda_role.lambda_iam_role_arn
}

# Used in tandem with the Corelight Sensor Module: https://github.com/corelight/terraform-aws-sensor
module "enrichment_sensor_role" {
  source = "github.com/corelight/terraform-aws-enrichment//modules/iam/sensor"
  enrichment_bucket_arn = aws_s3_bucket.enrichment_bucket.arn
}

resource "aws_iam_instance_profile" "corelight_sensor" {
  name = "corelight-sensor-profile"
  role = module.enrichment_sensor_role.sensor_role_name
}

```

## Preparation

Image based Lambdas must be deployed from a private Elastic Container Registry (ECR)
repository and therefore the data collection serverless container image provided by
Corelight must be copied from Dockerhub and pushed to your own ECR repository.

#### Create the ECR Repository (CLI)
```bash
aws ecr create-repository --repository-name corelight/sensor-enrichment-aws
```

#### Create the ECR Repository (Terraform)
```terraform
resource "aws_ecr_repository" "enrichemnt_repo" {
  name = "corelight/sensor-enrichment-aws"
}
```

#### Copying the Corelight image
Log into the AWS account's registry

```bash
aws ecr get-login-password --region <region> | docker login \
    --username AWS \
    --password-stdin <[account id].dkr.ecr.[region].amazonaws.com>
```

Corelight recommends installing [skopeo](https://github.com/containers/skopeo/blob/main/install.md) to assist with copying this image.
```bash
AWS_ACCOUNT=<enter aws account id>
AWS_REGION=<enter ecr repository region>
ECR_REGISTRY="${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# Pull from Dockerhub
CORELIGHT_REPO=corelight
CORELIGHT_IMAGE_NAME=sensor-enrichment-aws
CORELIGHT_IMAGE_TAG=0.1.1

# Dockerhub image: corelight/sensor-enrichment-aws:0.1.1
SRC_IMAGE="$CORELIGHT_REPO/$CORELIGHT_IMAGE_NAME:$CORELIGHT_IMAGE_TAG"

# ECR Destination: <AWS_ACCOUNT>.dkr.ecr.<AWS_REGION>.amazonaws.com/corelight/sensor-enrichment-aws:0.1.1
DST_IMAGE="$ECR_REGISTRY/$CORELIGHT_REPO/$CORELIGHT_IMAGE_NAME:$CORELIGHT_IMAGE_TAG"

# Pull Corelight Image
docker pull $SRC_IMAGE

# Copy Image to ECR
skopeo copy docker://$SRC_IMAGE docker://$DST_IMAGE --dest-tls-verify -all
```
If you would prefer not to use Skopeo then the image will need to be pulled, tagged, and pushed
to ECR manually.

```bash
AWS_ACCOUNT=<enter aws account id>
AWS_REGION=<enter ecr repository region>
ECR_REGISTRY="${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# Pull from Dockerhub
CORELIGHT_REPO=corelight
CORELIGHT_IMAGE_NAME=sensor-enrichment-aws
CORELIGHT_IMAGE_TAG=0.1.1

# Dockerhub image: corelight/sensor-enrichment-aws:0.1.1
SRC_IMAGE="$CORELIGHT_REPO/$CORELIGHT_IMAGE_NAME:$CORELIGHT_IMAGE_TAG"

# ECR Destination: <AWS_ACCOUNT>.dkr.ecr.<AWS_REGION>.amazonaws.com/corelight/sensor-enrichment-aws:0.1.1
DST_IMAGE="$ECR_REGISTRY/$CORELIGHT_REPO/$CORELIGHT_IMAGE_NAME:$CORELIGHT_IMAGE_TAG"

# Pull Corelight Image
docker pull $SRC_IMAGE --platform linux/arm64

docker image tag $SRC_IMAGE $DST_IMAGE

docker image push $DST_IMAGE
```

## Deployment

The variables for this module all have default values that can be overwritten
to meet your naming and compliance standards. The only variables without defaults are
the Lambda's ECR image name and tag which you will set during preparation.

Deployment examples can be found [here](examples)

## License

The project is licensed under the [MIT][] license.

[MIT]: LICENSE
