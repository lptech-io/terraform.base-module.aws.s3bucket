variable "bucket_name" {
  description = "The name of the S3 bucket to be created"
  type        = string
  validation {
    condition     = can(regex("^([a-z0-9][a-z0-9-]{1,61}[a-z0-9])$", var.bucket_name))
    error_message = "Bucket names can't contain dots and must match the regex '^([a-z0-9][a-z0-9-]{1,61}[a-z0-9])$'."
  }
}

variable "kms_key" {
  default     = null
  description = "The ARN of the KMS key for bucket's encryption. If not set, the default AWS/S3 key will be used"
  type        = string
}

variable "logging_configuration" {
  default = {
    bucket_name = null
    enabled     = false
    prefix      = null
  }
  description = "Logging configuration block"
  type = object({
    bucket_name = optional(string)
    enabled     = optional(bool, false)
    prefix      = optional(string)
  })
  validation {
    condition     = can(var.logging_configuration.enabled == false && var.logging_configuration.bucket_name == null && var.logging_configuration.prefix == null)
    error_message = "If logging configuration is disabled don't set the bucket_name and prefix"
  }
  validation {
    condition     = can(var.logging_configuration.enabled && var.logging_configuration.bucket_name != null && var.logging_configuration.prefix != null)
    error_message = "If logging configuration is enabled the bucket_name and prefix must be set"
  }
}

variable "public_access_configuation" {
  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
  description = "Public access configuration block"
  type = object({
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
  })
}

variable "versioning_enabled" {
  default     = false
  description = "Enable versioning on the bucket"
  type        = bool
}