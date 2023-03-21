variable "cluster_id" {
  description = "The ECS cluster ID"
  type        = string
}

variable "ACCOUNT_ID" {
  description = "amazon account id (keep secret)"
  type        = string
  default     = 649206692878
  sensitive   = true
}

variable "REGION" {
  description = "the amazon region beign used"
  type        = string
  default     = "us-east-1"
}

variable "TAG" {
  description = "the app image tag"
  type        = string
  default     = "jenkins"
}

variable "NAME" {
  description = "the app name"
  type        = string
  default     = "bank"
}

variable "HOST_PORT" {
  description = "the host port"
  type        = string
  default     = "8083"
}

variable "APP_PORT" {
  description = "the app port"
  type        = string
  default     = "8083"
}

variable "DB_USERNAME" {
  description = "the db username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "DB_PASSWORD" {
  description = "the db password"
  type        = string
  sensitive   = true
}

variable "DB_HOST" {
  description = "the db host"
  type        = string
}

variable "DB_PORT" {
  description = "the db port"
  type        = string
  default     = "3306"
}

variable "DB_NAME" {
  description = "the db name"
  type        = string
  default     = "aline_db"
}

variable "ENCRYPT_SECRET_KEY" {
  description = "the encryption secret key"
  type        = string
  sensitive   = true
}

variable "JWT_SECRET_KEY" {
  description = "the jwt secret key"
  type        = string
  sensitive   = true
}

variable "cpu" {
  description = "vcpu for the container"
  type        = number
  default     = 512
}

variable "memory" {
  description = "memory for the container"
  type        = number
  default     = 300
}
