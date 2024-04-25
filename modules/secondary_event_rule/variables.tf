variable "secondary_ec2_state_change_rule_name" {
  type        = string
  description = "Name of the secondary EC2 state change rule"
}

variable "primary_event_bus_arn" {
  type        = string
  description = ""
}

variable "cross_region_iam_role_arn" {
  type        = string
  description = ""
}

variable "tags" {
  type        = object({})
  description = "Any tags that should be applied to resources deployed by the module"
  default = {}
}