module "db" {
  source = "terraform-aws-modules/rds/aws"
  version = "5.1.0"

  identifier = "ln-aline-db"
  create_db_instance = true

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.medium"
  allocated_storage = 5

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = "3306"

  create_random_password = false

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [var.sg_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "ln-MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "admin"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.database_subnets

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
