variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ecs_task_execution_role_arn" {
  description = "Existing IAM Role ARN for ECS Task Execution"
  type        = string
}

variable "dockerhub_image" {
  description = "DockerHub image URL for Medusa container"
  type        = string
  default     = "yourdockerhubuser/medusa-backend:latest"
}

variable "db_username" {
  description = "Master DB username"
  type        = string
  default     = "medusa_user"
}

variable "db_password" {
  description = "Master DB password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "medusadb"
}

variable "jwt_secret" {
  description = "JWT secret key for Medusa"
  type        = string
  sensitive   = true
}
