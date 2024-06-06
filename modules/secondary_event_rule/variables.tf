variable "secondary_ec2_state_change_rule_name" {
  description = "Name of the secondary EC2 state change rule"
  type        = string
}

variable "primary_event_bus_arn" {
  description = "ARN of the primary Corelight event bus which all events should fan in to"
  type        = string
}

variable "cross_region_eventbridge_role_arn" {
  description = "ARN of the eventbridge IAM role granting permission to put events on the Corelight primary Event Bus"
  type        = string
}

### Variables with Defaults
variable "tags" {
  description = "(optional) Any tags that should be applied to resources deployed by the module"
  type        = object({})
  default     = {}
}
