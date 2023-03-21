locals {
  name = "vms"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["one", "two", "three"])

  name = "instance-${each.key}"

  ami                    = "ami-0ab0629dba5ae551d"
  instance_type          = "t2.micro"
  key_name               = "ansible2"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = "subnet-0c805ea6718df65ce"

  tags = {
    Name        = "vms"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "sg" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-0a607e64538caad29"

  ingress {
    description = "All from internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

resource "aws_route53_record" "ln-ansible" {
  name    = "lna.hashnet-jenkins.click"
  zone_id = "Z011607819I9ZV7GVI23Z"
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}

output "instance_ids" {
  value = [for instance in module.ec2_instance : instance]
}

output "instance_targets" {
  value = { for name, instance in module.ec2_instance : name => { target_id = instance.id, port = 80 } }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "ln-ansible-alb"

  load_balancer_type = "application"

  vpc_id          = "vpc-0a607e64538caad29"
  subnets         = ["subnet-075820e9865050dcd", "subnet-0c805ea6718df65ce"]
  security_groups = [aws_security_group.sg.id]

  target_groups = [
    {
      name_prefix      = "lna-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets          = { for name, instance in module.ec2_instance : name => { target_id = instance.id, port = 80 } }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}
