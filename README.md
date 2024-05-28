# terraform-aws-enrichment

<img src="docs/overview.svg" alt="overview">

## Usage
```terraform

module "enrichment" {
  source = "github.com/corelight/terraform-aws-enrichment"

  corelight_cloud_enrichment_image = "123456789111.dkr.ecr.us-east-1.amazonaws.com/corelight-sensor-enrichment-aws"
  corelight_cloud_enrichment_image_tag = "0.1.0"
  enrichment_bucket_name = "corelight-enrichment"
}
```

## Preparation

Image based Lambdas must be deployed from a private Elastic Container Registry (ECR) 
repository and therefore the data collection serverless container image provided by 
Corelight must be copied from Dockerhub and pushed to your own ECR repository.

#### Copying the Corelight image
Log into the destination ECR

```bash
aws ecr get-login-password --region <region> | docker login \
    --username AWS \
    --password-stdin <[account id].dkr.ecr.[region].amazonaws.com>
```

Corelight recommends install [skopeo](https://github.com/containers/skopeo/blob/main/install.md) to assist with copying this image.
```bash
AWS_ACCOUNT=<enter aws account id>
AWS_REGION=<enter ecr repository region>
ECR_REGISTRY="${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# Pull from Dockerhub
CORELIGHT_REPO=corelight
CORELIGHT_IMAGE_NAME=sensor-enrichment-aws
CORELIGHT_IMAGE_TAG=0.1.0

SRC_IMAGE="$CORELIGHT_REPO/$CORELIGHT_IMAGE_NAME:$CORELIGHT_IMAGE_TAG"
DST_IMAGE="$ECR_REGISTRY/$CORELIGHT_IMAGE_NAME:$CORELIGHT_IMAGE_TAG"

# Pull Corelight Image
docker pull $SRC_IMAGE

# Copy Image to ECR
skopeo copy docker://$SRC_IMAGE docker://$DST_IMAGE --dest-tls-verify
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
CORELIGHT_IMAGE_TAG=0.1.0

SRC_IMAGE="$CORELIGHT_REPO/$CORELIGHT_IMAGE_NAME:$CORELIGHT_IMAGE_TAG"
DST_IMAGE="$ECR_REGISTRY/$CORELIGHT_IMAGE_NAME:$CORELIGHT_IMAGE_TAG"

# Pull Corelight Image
docker pull $SRC_IMAGE

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