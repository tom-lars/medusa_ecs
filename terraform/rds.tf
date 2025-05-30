resource "aws_db_subnet_group" "default" {
  name       = "medusa-db-subnet-group"
  subnet_ids = aws_subnet.public[*].id

  tags = {
    Name = "medusa-db-subnet-group"
  }
}

resource "aws_db_instance" "medusa_db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15.7"
  instance_class       = "db.t3.micro"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  publicly_accessible  = true
  skip_final_snapshot  = true

  tags = {
    Name = "medusa-db-instance"
  }
}

