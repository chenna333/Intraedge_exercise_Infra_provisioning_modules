###################################
# AWS RDS PostgreSQL Module
###################################

resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "db_secret" {
  name        = "${var.db_identifier}-credentials"
  description = "PostgreSQL credentials for ${var.db_identifier}"
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = var.username
    password = random_password.db_password.result
  })
}

###################################
# Subnet group for DB
###################################
resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}

###################################
# Security group (optional)
###################################
resource "aws_security_group" "postgres_sg" {
  count       = var.create_sg ? 1 : 0
  name        = "${var.db_identifier}-sg"
  description = "Security group for PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_identifier}-sg"
  }
}

###################################
# PostgreSQL RDS Instance
###################################
resource "aws_db_instance" "postgres" {
  identifier              = var.db_identifier
  engine                  = "postgres"
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = random_password.db_password.result
  publicly_accessible     = var.publicly_accessible
  storage_encrypted       = true
  skip_final_snapshot     = true
  deletion_protection     = false
  vpc_security_group_ids  = var.create_sg ? [aws_security_group.postgres_sg[0].id] : var.vpc_security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.postgres_subnet_group.name
  apply_immediately       = true
  multi_az                = false

  tags = {
    Name = var.db_identifier
  }
}

###################################
# Schema creation
###################################
resource "null_resource" "create_schemas" {
  depends_on = [aws_db_instance.postgres]

  provisioner "local-exec" {
    command = <<EOT
      echo "Creating schemas in PostgreSQL..."
      export PGPASSWORD='${random_password.db_password.result}'
      psql -h ${aws_db_instance.postgres.address} -U ${var.username} -d ${var.db_name} -p 5432 -c "CREATE SCHEMA IF NOT EXISTS app;"
      psql -h ${aws_db_instance.postgres.address} -U ${var.username} -d ${var.db_name} -p 5432 -c "CREATE SCHEMA IF NOT EXISTS schema;"
    EOT
  }
}

