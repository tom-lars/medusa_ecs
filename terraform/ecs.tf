resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-cluster"
}

resource "aws_ecs_task_definition" "medusa_task" {
  family                   = "medusa-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([{
    name      = "medusa"
    image     = var.dockerhub_image
    essential = true
    portMappings = [{
      containerPort = 9000
      hostPort      = 9000
    }]
    environment = [
      {
        name  = "JWT_SECRET"
        value = var.jwt_secret
      },
      {
        name  = "DATABASE_URL"
        value = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.medusa_db.address}:5432/${var.db_name}"
      }
    ]
  }])
}

resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = aws_subnet.public[*].id
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_service_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "medusa"
    container_port   = 9000
  }

  depends_on = [aws_lb_listener.http_listener]
}


