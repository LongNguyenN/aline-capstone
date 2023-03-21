
################################################################################
# ECS Module
################################################################################

module "ecs" {
  source  = "../modules/ecs"

  auto_scaling_group_arns = module.autoscaling.auto_scaling_group_arns
}

module "service" {
  source = "../modules/service"

  for_each = {
    "bank" = {
      APP_PORT  = "8083"
      HOST_PORT = "8083"
      TAG       = "cream"
      cpu       = 512
      memory    = 350
    },
    "underwriter" = {
      APP_PORT  = "8071"
      HOST_PORT = "8071"
      TAG       = "cream"
      cpu       = 512
      memory    = 350
    },
    "user" = {
      APP_PORT  = "8070"
      HOST_PORT = "8070"
      TAG       = "cream"
      cpu       = 512
      memory    = 350
    },
    "transaction" = {
      APP_PORT  = "8073"
      HOST_PORT = "8073"
      TAG       = "cream"
      cpu       = 512
      memory    = 350
    },
    "landing-portal" = {
      APP_PORT  = "3000"
      HOST_PORT = "3000"
      TAG       = "alpha"
      cpu       = 1024
      memory    = 800
    },
    "admin-portal" = {
      APP_PORT  = "3000"
      HOST_PORT = "3001"
      TAG       = "light"
      cpu       = 512
      memory    = 350
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

################################################################################
# Supporting Resources
################################################################################

module "autoscaling" {
  source = "../modules/asg"

  vpc_id            = var.vpc_id
  private_subnets   = var.private_subnets
  target_group_arns = module.alb.target_group_arns
}

module "alb" {
  source = "../modules/alb"

  public_subnets = var.public_subnets
  vpc_id         = var.vpc_id
}

