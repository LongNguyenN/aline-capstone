variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "private_subnets" {
  description = "private subnets"
  type        = list(string)
}

variable "target_group_arns" {
  description = "list of alb target group arns"
  type        = list(string)
}
