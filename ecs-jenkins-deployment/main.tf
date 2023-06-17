provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_lb" "jenkins_nlb" {
  name               = var.nlb_name
  load_balancer_type = "network"
  subnets            = var.public_subnets

  tags = {
    Name = var.nlb_name
  }
}

resource "aws_lb_target_group" "jenkins_target_group_http" {
  name     = var.http_target_group_name
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id

  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/elb-healthcheck"
  }
}

resource "aws_lb_listener" "jenkins_listener_http" {
  load_balancer_arn = aws_lb.jenkins_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_target_group_http.arn
  }
}

resource "aws_lb_target_group" "jenkins_target_group_https" {
  name     = var.https_target_group_name
  port     = 8090
  protocol = "TCP"
  vpc_id   = var.vpc_id

  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/elb-healthcheck"
  }
}

resource "aws_lb_listener" "jenkins_listener_https" {
  load_balancer_arn = aws_lb.jenkins_nlb.arn
  port              = 443
  protocol          = "TLS"

  ssl_policy      = var.https_listener_ssl_policy
  certificate_arn = var.https_listener_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_target_group_https.arn
  }
}

resource "aws_security_group" "jenkins_security_group" {
  name        = var.ecs_security_group_name
  description = "Security group for Jenkins ECS Service Tasks"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "jenkins_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_cloudwatch_log_group" "jenkins_logs" {
  name              = "/ecs/jenkins-logs"
  retention_in_days = 5
}

resource "aws_ecs_task_definition" "jenkins_task_definition" {
  family                = var.ecs_task_family
  container_definitions = <<EOF
  [
    {
      "name": "jenkins",
      "image": "${var.jenkins_image}",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.ecs_service_log_group_name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "jenkins"
        }
      }
    },
    {
      "name": "nginx",
      "image": "${var.nginx_image}",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${var.ecs_service_log_group_name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "nginx"
        }
      },
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        },
        {
          "containerPort": 8090,
          "hostPort": 8090,
          "protocol": "tcp"
        }
      ]
    }
  ]
  EOF

  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  network_mode             = "awsvpc"

  execution_role_arn = var.ecs_execute_role_arn
}

resource "aws_ecs_service" "jenkins_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.jenkins_cluster.id
  task_definition = aws_ecs_task_definition.jenkins_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.jenkins_security_group.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.jenkins_target_group_https.arn
    container_name   = "nginx"
    container_port   = 8090
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.jenkins_target_group_http.arn
    container_name   = "nginx"
    container_port   = 80
  }
}
