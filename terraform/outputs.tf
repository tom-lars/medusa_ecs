output "database_url" {
  value       = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.medusa_db.address}:5432/${var.db_name}"
  description = "PostgreSQL database connection URL for Medusa"
  sensitive   = true
}

output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "DNS name of the Application Load Balancer"
}
