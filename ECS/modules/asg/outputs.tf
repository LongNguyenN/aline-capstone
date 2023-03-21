output "auto_scaling_group_arns" {
  description = "list of autoscaling gorup arns"
  value       = {
    for k, arn in module.autoscaling : k => arn.autoscaling_group_arn
  }
}
