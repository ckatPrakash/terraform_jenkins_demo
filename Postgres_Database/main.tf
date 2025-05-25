provider "aws" {
   region = "us-east-1"
}

terraform {
required_providers {
postgresql = {
	source = "cyrilgdn/postgresql"
	version = "~> 1.20.0"
}
}
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "postgres-db-credentials12"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "admin1234567"
    password = "MySecurePassword1234!"
  })
}

# Fetch default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch default subnets in the default VPC (usually in all AZs)
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow PostgreSQL"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Use with caution! Use your IP range in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


provider "postgresql" {
host= var.db_host
username = var.db_user
password = var.db_password
port = var.db_port
sslmode = "disable"
connect_timeout = 15
}

resource "aws_db_instance" "postgresql" {
identifier = "my-postgres-db"
allocated_storage = 20
engine = "postgres"
engine_version = "16"
instance_class = "db.t3.micro"
storage_type = "gp2"
storage_encrypted = true
db_name = var.db_name
username = jsondecode(aws_secretsmanager_secret_version.db_secret_version.secret_string)["username"]
password= jsondecode(aws_secretsmanager_secret_version.db_secret_version.secret_string)["password"]
port = 5432
multi_az= false
db_subnet_group_name = aws_db_subnet_group.default.name
vpc_security_group_ids = [aws_security_group.rds_sg.id]
publicly_accessible=true
skip_final_snapshot = true
tags = {
	Name = "Postgres_DB_Instance"
}
}

output "db_address" {
  value = aws_db_instance.postgresql.address
}