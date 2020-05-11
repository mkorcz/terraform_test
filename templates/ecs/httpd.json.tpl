[
  {
    "name": "httpd",
    "image": "${app_image}",
    "cpu": ${cpu-value},
    "memory": ${memory-value},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "httpd-app",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "stream"
        }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port},
        "protocol": "tcp"
      }
    ]
  }
]