variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-east-2"
}

variable "vpc_id" {
  type    = string
  default = "vpc-123456"
  description = "VPC ID"
}

variable "public_subnets" {
  type    = list(string)
  default = ["subnet-123456", "subnet-456789"]
  description = "Public subnets where we need to deploy the NLB"
}

variable "private_subnets" {
  type    = list(string)
  default = ["subnet-0123456", "subnet-abc745"]
  description = "Private subnets where we need to create the tasks"
}

variable "nlb_name" {
  type    = string
  default = "test-jenkins-nlb"
}

variable "http_target_group_name" {
  type    = string
  default = "test-jenkins-target-group-http"
}

variable "https_target_group_name" {
  type    = string
  default = "test-jenkins-target-group-https"
}

variable "https_listener_certificate_arn" {
  type    = string
  default = "arn:aws:acm:us-east-2:123456789012:certificate/123456-acdf-3467-feab-a6a678318932"
}

variable "https_listener_ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-2016-08"
}

variable "ecs_security_group_name" {
  type    = string
  default = "test-jenkins-security-group"
}

variable "ecs_task_family" {
  type    = string
  default = "test-jenkins-task"
}

variable "ecs_cluster_name" {
  type    = string
  default = "test-jenkins-cluster"
}

variable "ecs_service_name" {
  type    = string
  default = "test-jenkins-service"
}

variable "ecs_task_memory" {
  type    = string
  default = "8192"
}

variable "ecs_task_cpu" {
  type    = string
  default = "2048"
}

variable "ecs_service_log_group_name" {
  type    = string
  default = "/ecs/jenkins-logs"
}

variable "ecs_execute_role_arn" {
  type    = string
  default = "arn:aws:iam::123456789012:role/customEcsTaskRole"
  description = "This role is to create and delete tasks and create and delete logstreams and push events"
}

variable "jenkins_image" {
  type    = string
  default = "jenkins/jenkins:lts"
}

variable "nginx_image" {
  type    = string
  default = "avasant21/aws-ecs-jenkins-nginx:1.0"
}
