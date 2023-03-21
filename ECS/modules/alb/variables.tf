variable "public_subnets" {
  description = "vpc public subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}
