variable "sg_id" {
  description = "put in the autoscaling security group id for now"
  type        = string
  default     = "sg-021dc6ba47baa97fb"
}

variable "database_subnets" {
  description = "database subnets from vpc"
  type        = list(string)
  default = ["subnet-08895e24bd21b30ab", "subnet-0538bb5aa81f03470"]
}

variable "db_name" {
  description = "database name"
  type        = string
  default     = "aline_db"
}

variable "username" {
  description = "database user name"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "database password"
  type        = string
  sensitive   = true
}
