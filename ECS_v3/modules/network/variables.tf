variable "name" {
  description = "Name for all network resources"
  type        = string
  default     = "ln-network"
}

variable "region" {
  description = "aws region"
  type        = string
  default     = "us-east-2"
}
