resource "aws_cloudwatch_log_group" "this" {
  name_prefix       = "service-"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "this" {
  family = var.NAME

  container_definitions = <<EOF
	[
	  {
	    "name": "${var.NAME}",
	    "image": "${var.ACCOUNT_ID}.dkr.ecr.${var.REGION}.amazonaws.com/ln/${var.NAME}:${var.TAG}",
	    "cpu": ${var.cpu},
	    "memory": ${var.memory},
	   "portMappings": [
	     {
	       "containerPort": ${var.APP_PORT},
	       "hostPort": ${var.HOST_PORT}
	     }
	   ],
	    "environment": [
	      {"name": "APP_PORT", "value": "${var.APP_PORT}"},
	      {"name": "DB_USERNAME", "value": "${var.DB_USERNAME}"},
	      {"name": "DB_PASSWORD", "value": "${var.DB_PASSWORD}"},
	      {"name": "DB_HOST", "value": "${var.DB_HOST}"},
	      {"name": "DB_PORT", "value": "${var.DB_PORT}"},
	      {"name": "DB_NAME", "value": "${var.DB_NAME}"},
	      {"name": "ENCRYPT_SECRET_KEY", "value": "${var.ENCRYPT_SECRET_KEY}"},
	      {"name": "JWT_SECRET_KEY", "value": "${var.JWT_SECRET_KEY}"}
	    ],
	    "logConfiguration": {
	      "logDriver": "awslogs",
	      "options": {
		"awslogs-region": "us-east-2",
		"awslogs-group": "${aws_cloudwatch_log_group.this.name}",
		"awslogs-stream-prefix": "ec2"
	      }
	    }
	  }
	]
  EOF
}

resource "aws_ecs_service" "this" {
  name            = "service_${var.NAME}"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}
