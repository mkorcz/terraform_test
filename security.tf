resource "aws_security_group" "lb" {
  name = "load-balancer-security-group"
  description = "security_group"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    from_port = var.app_port
    to_port = var.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_task" {
  name = "ecs-task-security-group"
  description = "allow inbound from alb"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    from_port = var.app_port
    to_port = var.app_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}