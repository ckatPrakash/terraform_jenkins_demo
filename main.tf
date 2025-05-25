provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source         = "./EC2_Instance"
  #ami            = "ami-0c55b159cbfafe1f0"
  #instance_type  = "t2.micro"
}

module "postgres" {
  source = "./Postgres_Database"

  # You can pass EC2 outputs to this module if needed
  # For example:
  # ec2_instance_id = module.ec2.ec2_instance_id
}
