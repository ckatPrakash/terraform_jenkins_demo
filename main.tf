provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source         = "./EC2_Instance"
}

module "postgres" {
  source = "./Postgres_Database"

  # You can pass EC2 outputs to this module if needed
  # For example:
  # ec2_instance_id = module.ec2.ec2_instance_id
}
