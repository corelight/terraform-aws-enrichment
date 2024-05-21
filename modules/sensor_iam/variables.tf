variable "enrichment_bucket_arn" {
  description = "ARN of the enrichment bucket the sensor will need to read from"
  type        = string
}

### Variables with Defaults
variable "corelight_sensor_role_name" {
  description = "Name of the role created to read the "
  type        = string
  default     = "corelight-sensor-cloud-enrichment-role"
}

variable "corelight_sensor_policy_name" {
  description = ""
  type        = string
  default     = "corelight-sensor-cloud-enrichment-policy"
}

variable "tags" {
  description = "Any tags that should be applied to resources deployed by the module"
  type        = object({})
  default     = {}
}