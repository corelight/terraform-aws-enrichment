variable "primary_event_bus_arn" {
  description = "ARN of the primary event bus that all events will fan-in to"
  type        = string
}

### Variables with defaults
variable "cross_region_event_bus_policy_name" {
  description = "Name of the Corelight Event Bus"
  type        = string
  default     = "corelight-primary-event-bus-policy"
}

variable "cross_region_event_bus_role_name" {
  description = "Name of the IAM Role granting "
  type        = string
  default     = "corelight-cross-region-event-role"
}

variable "tags" {
  description = "(optional) Any tags that should be applied to resources deployed by the module"
  type        = object({})
  default     = {}
}
