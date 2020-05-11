variable "aws_region" {
  description = "AWS Region"
  default = "eu-north-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description = "vpc ip adress"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}
variable "app_count" {
  default = 1
}

variable "public_subnet_1" {
  default = "10.0.1.0/24"
  description = "public subnet adress"

}

variable "public_subnet_2" {
  default = "10.0.2.0/24"
  description = "public subnet adress"

}

variable "private_subnet_1" {
  default = "10.0.3.0/24"
  description = "private subnet adress"

}

variable "private_subnet_2" {
  default = "10.0.4.0/24"
  description = "private subnet adress"

}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "ECS_EXECUTION_ROLE"
}

variable "docker_image_url" {
  description = "Docker image"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}
variable "health_check_path" {
  default = "/"
}

variable "cpu-value" {
  description = "CPU units"
  default     = "1024"
}

variable "memory-value" {
  description = "Instance memory"
  default     = "2048"
}


