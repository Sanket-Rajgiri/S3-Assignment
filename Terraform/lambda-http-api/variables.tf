
variable "regions" {
  type = map(any)
  description = "Map of environment specific region"
}


variable "architectures" {
  description = "The instruction set architecture for the Lambda function. Options: [x86_64, arm64]"
  type        = list(string)
  default     = ["x86_64"]
}

variable "memory_size" {
  description = "The amount of memory available to the Lambda function in MB. Default is 128 MB"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "The amount of time (in seconds) that Lambda allows a function to run before stopping it"
  type        = number
  default     = 3
}

variable "package_type" {
  description = "The deployment package type for the Lambda function. Options: 'Image' or 'Zip'"
  type        = string
  default     = "Zip"
}

variable "handler" {
  description = "The function entry point in your code (required if package_type is 'Zip')"
  type        = string
  default     = null
}

variable "runtime" {
  description = "The runtime environment for the Lambda function (e.g., python3.9, nodejs16.x). Required if package_type is 'Zip'"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Key-value map of environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "create_role" {
  description = "Whether to create a new role for Lambda or use existing one"
  type = bool
  default = true
}
variable "role" {
  description = "The ARN of an IAM role to use for the Lambda function. If not provided, a new role is created"
  type        = string
  default     = null
}

variable "override_default_role_name_with" {
  description = "Override the default IAM role name for the Lambda function"
  type        = string
  default     = null
}

variable "log_retention_in_days" {
  description = "The number of days to retain the logs in CloudWatch"
  type        = number
  default     = 14
}

variable "ephemeral_storage" {
  description = "The size of ephemeral storage for the Lambda function in MB (default: 512 MB)"
  type        = number
  default     = 512
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}


variable "configuration" {
  type = any 
  description = "Map of Configuration for different environments"
}