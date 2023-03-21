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

################################################################################
# ECS Module
################################################################################

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.2"

  cluster_name = local.name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        # You can set a simple string and ECS will create the CloudWatch log group for you
        # or you can create the resource yourself as shown here to better manage retetion, tagging, etc.
        # Embedding it into the module is not trivial and therefore it is externalized
        cloud_watch_log_group_name = aws_cloudwatch_log_group.this.name
      }
    }
  }

  default_capacity_provider_use_fargate = false

  # Capacity provider - Fargate
  fargate_capacity_providers = {
    FARGATE      = {}
    FARGATE_SPOT = {}
  }

  # Capacity provider - autoscaling groups
  autoscaling_capacity_providers = {
    uno = {
      auto_scaling_group_arn         = module.autoscaling["one"].autoscaling_group_arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 5
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 60
      }

      default_capacity_provider_strategy = {
        weight = 60
        base   = 20
      }
    }
    two = {
      auto_scaling_group_arn         = module.autoscaling["two"].autoscaling_group_arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 15
        minimum_scaling_step_size = 5
        status                    = "ENABLED"
        target_capacity           = 90
      }

      default_capacity_provider_strategy = {
        weight = 40
      }
    }
  }

  tags = local.tags
}

module "service" {
  source = "../modules/service"

  for_each = {
    "bank" = {
      APP_PORT  = "8083"
      HOST_PORT = "8083"
      TAG       = "cream"
      cpu       = 450
      memory    = 300
    },
    "underwriter" = {
      APP_PORT  = "8071"
      HOST_PORT = "8071"
      TAG       = "cream"
      cpu       = 450
      memory    = 300
    },
    "user" = {
      APP_PORT  = "8070"
      HOST_PORT = "8070"
      TAG       = "cream"
      cpu       = 450
      memory    = 300
    },
    "transaction" = {
      APP_PORT  = "8073"
      HOST_PORT = "8073"
      TAG       = "cream"
      cpu       = 450
      memory    = 300
    },
    "landing-portal" = {
      APP_PORT  = "3000"
      HOST_PORT = "3000"
      TAG       = "jenkins"
      cpu       = 1024
      memory    = 600
    },
    "admin-portal" = {
      APP_PORT  = "3000"
      HOST_PORT = "3001"
      TAG       = "light"
      cpu       = 450
      memory    = 300
    }
  }

  cpu                = each.value.cpu
  memory             = each.value.memory
  cluster_id         = module.ecs.cluster_id
  TAG                = each.value.TAG
  NAME               = each.key
  APP_PORT           = each.value.APP_PORT
  HOST_PORT          = each.value.HOST_PORT
  DB_HOST            = var.db_endpoint
  DB_PASSWORD        = var.db_password
  JWT_SECRET_KEY     = var.jwt_secret_key
  ENCRYPT_SECRET_KEY = var.encrypt_secret_key
}

module "ecs_disabled" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.2"

  create = false
}

################################################################################
# Supporting Resources
################################################################################

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html#ecs-optimized-ami-linux
data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.5"

  for_each = {
    one = {
      instance_type = "t3.micro"
      max = 2
    }
    two = {
      instance_type = "t3.small"
      max = 1
    }
  }

  name = "${local.name}-${each.key}"

  image_id      = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
  instance_type = each.value.instance_type

  security_groups                 = [module.autoscaling_sg.security_group_id]
  user_data                       = base64encode(local.user_data)
  ignore_desired_capacity_changes = true

  create_iam_instance_profile = true
  iam_role_name               = local.name
  iam_role_description        = "ECS role for ${local.name}"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  vpc_zone_identifier = var.private_subnets
  health_check_type   = "EC2"
  min_size            = 0
  max_size            = each.value.max
  desired_capacity    = 1

  # https://github.com/hashicorp/terraform-provider-aws/issues/12582
  autoscaling_group_tags = {
    AmazonECSManaged = true
  }

  # Required for  managed_termination_protection = "ENABLED"
  protect_from_scale_in = true

  target_group_arns = module.alb.target_group_arns

  tags = local.tags
}

module "autoscaling_sg" {
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

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${local.name}"
  retention_in_days = 7

  tags = local.tags
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.2.1"

  name = local.name

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.public_subnets
  security_groups = [module.autoscaling_sg.security_group_id]

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
