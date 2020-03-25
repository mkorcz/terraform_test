/*
data "aws_ecs_task_definition" "httpd"{
  task_definition = aws_ecs_task_definition.httpd.family

}

resource "aws_ecs_cluster" "main" {
  name="httpd-cluster"
}

resource "aws_ecs_task_definition" "httpd" {
  family = "httpd-family"
  container_definitions = <<DEFINITION
[
  {
    "cpu": 128,
    "environment": [{
      "name": "SECRET",
      "value": "KEY"
    }],
    "essential": true,
    "image": "mongo:latest",
    "memory": 128,
    "memoryReservation": 64,
    "name": "httpd"
  }
]
DEFINITION
}

resource "aws_ecs_service" "httpd" {
  name = "httpd"
  cluster = aws_ecs_cluster.main.id
  desired_count = 1
  task_definition = "${aws_ecs_task_definition.httpd.family}:${max("${aws_ecs_task_definition.httpd.revision}", "${data.aws_ecs_task_definition.httpd.revision}")}"
}

*/

resource "aws_iam_role" "test_role" {
  name = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.policy-test.json
}

data "aws_iam_policy_document" "policy-test" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "test-attach" {
role = aws_iam_role.test_role.name
policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}


resource "aws_ecs_cluster" "main" {
  name = "httpd-cluster"
}

resource "docker_image" "httpd" {
  name = "httpd:latest"
}

data "template_file" "httpd_app" {
  template = file("./templates/ecs/httpd.json.tpl")

  vars = {
    app_image      = docker_image.httpd.name
    app_port       = var.app_port
    cpu-value      = var.cpu-value
    memory-value   = var.memory-value
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "httpd-app-task"
  execution_role_arn       = aws_iam_role.test_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu-value
  memory                   = var.memory-value
  container_definitions    = data.template_file.httpd_app.rendered
}

resource "aws_ecs_service" "main" {
  name            = "httpd"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_task.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "httpd"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.front, aws_iam_role_policy_attachment.test-attach]
}



