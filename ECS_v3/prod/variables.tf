variable "db_username" {
  description = "username for the rds"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "password for the rds"
  type        = string
  sensitive   = true
}

variable "jwt_secret_key" {
  description = "the jwt secret key"
  type        = string
  sensitive   = true
}

variable "encrypt_secret_key" {
  description = "the encryption secret key"
  type        = string
  sensitive   = true
}

variable "db_endpoint" {
  description = "endpoint for database"
  type        = string
  sensitive   = true
  default     = "ln-aline-db.cjwtsdav4jkp.us-east-2.rds.amazonaws.com"
}

variable "vpc_id" {
  description = "id of the vpc"
  type        = string
  default     = "vpc-0f8bfa1deb26e661a"
}

variable "public_subnets" {
  description = "list of public subnet ids"
  type        = list(string)
  default     = ["subnet-02d72aca035d60bdd", "subnet-011eeae51e9acf82e"]
}

variable "private_subnets" {
  description = "list of private subnets"
  type        = list(string)
  default = ["subnet-03250d27ee6e2c66d",
  "subnet-074570ad564e89e8f"]
}
