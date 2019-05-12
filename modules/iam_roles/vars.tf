variable "trusted_role_arns" {
  description = "ARNs of AWS entities who can assume these roles"
  default     = []
}

variable "description" {
  default ="Allows EC2 instances to call AWS services on your behalf."
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  default     = 3600
}

variable "create_role" {
  description = "Whether to create a role"
  default     = false
}

variable "role_name" {
  description = "IAM role name"
  default     = ""
}

variable "role_path" {
  description = "Path of IAM role"
  default     = "/"
}
variable "custom_role_policy_arns" {
  description = "List of ARNs of IAM policies to attach to IAM role"
  default     = []
}


variable "attach_readonly_policy" {
  description = "Whether to attach a readonly policy to a role"
  default     = false
}