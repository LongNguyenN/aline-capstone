output "target_group_arns" {
  description = "target group arns"
  value = module.alb.target_group_arns
}

output "lb_dns_name" {
  description = "load balancer dns name"
  value = module.alb.lb_dns_name
}
