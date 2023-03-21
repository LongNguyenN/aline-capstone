module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                    = "ami-00eeedc4036573771"
  instance_type          = "t2.micro"
  key_name               = "ansible2"
  monitoring             = true
  vpc_security_group_ids = ["sg-0bd0e141f39b12a6d"]
  subnet_id              = "subnet-0c805ea6718df65ce"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name                = "terraform-test-foobar5"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "10"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions = ["arn:aws:automate:us-east-2:ec2:stop"]
  dimensions = { InstanceId = module.ec2_instance.id }
}
