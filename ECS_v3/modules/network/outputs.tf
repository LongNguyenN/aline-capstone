output "vpc_id" {
  description = "The ID of the vpc"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "the vpc's public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "the vpc's private subnets"
  value       = module.vpc.private_subnets
}

output "database_subnets" {
  description = "the vpc's database subnet"
  value       = module.vpc.database_subnets
}

output "cidr_block" {
  description = "default vpc cidr block"
  value       = module.vpc.vpc_cidr_block
}
