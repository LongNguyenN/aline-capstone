
locals {
  region = "eu-east-2"
  name   = "ln-ecs-${replace(basename(path.cwd), "_", "-")}"

  user_data = <<-EOT
    #!/bin/bash
    cat <<'EOF' >> /etc/ecs/ecs.config
    ECS_CLUSTER=${local.name}
    ECS_LOGLEVEL=debug
    EOF
  EOT

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ecs"
  }
}

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.name
  description = "Autoscaling group security group"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "all-all"]

  egress_rules = ["all-all"]

  tags = local.tags
}


resource "aws_route53_record" "ln-ecs" {
  zone_id = "Z011607819I9ZV7GVI23Z"
  name    = "ln-ecs.hashnet-jenkins.click"
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.2.1"

  name = local.name

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.public_subnets
  security_groups = [module.alb_sg.security_group_id]

  target_groups = [
    {
      name_prefix      = "sba"
      backend_protocol = "HTTP"
      backend_port     = 8083
      target_type      = "instance"
      health_check = {
        enabled  = true
        interval = 30
        path     = "/health"
      }
      targets = {}
    },
    {
      name_prefix      = "sun"
      backend_protocol = "HTTP"
      backend_port     = 8071
      target_type      = "instance"
      health_check = {
        enabled  = true
        interval = 30
        path     = "/health"
      }
      targets = {}
    },
    {
      name_prefix      = "sus"
      backend_protocol = "HTTP"
      backend_port     = 8070
      target_type      = "instance"
      health_check = {
        enabled  = true
        interval = 30
        path     = "/health"
      }
      targets = {}
    },
    {
      name_prefix      = "str"
      backend_protocol = "HTTP"
      backend_port     = 8073
      target_type      = "instance"
      health_check = {
        enabled  = true
        interval = 30
        path     = "/health"
      }
      targets = {}
    },
    {
      name_prefix      = "slp"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "instance"
      health_check = {
        enabled  = true
        interval = 30
        path     = "/"
      }
      targets = {}
    },
    {
      name_prefix      = "sap"
      backend_protocol = "HTTP"
      backend_port     = 3001
      target_type      = "instance"
      health_check = {
        enabled  = true
        interval = 30
        path     = "/"
      }
      targets = {}
    }

  ]

  http_tcp_listeners = [
    {
      port               = 8083
      protocol           = "HTTP"
      target_group_index = 0
    },
    {
      port               = 8071
      protocol           = "HTTP"
      target_group_index = 1
    },
    {
      port               = 8070
      protocol           = "HTTP"
      target_group_index = 2
    },
    {
      port               = 8073
      protocol           = "HTTP"
      target_group_index = 3
    },
    {
      port               = 3000
      protocol           = "HTTP"
      target_group_index = 4
    },
    {
      port               = 3001
      protocol           = "HTTP"
      target_group_index = 5
    }

  ]

  tags = {
    Environment = "Test"
  }
}
