provider "aws" {
region = "us-east-1"
}

resource "aws_security_group" "web_sg" {
 name = "web_sg"
 description = "Allow HTTP and SSH"

ingress {
    from_port = 80
	to_port = 80
	protocol= "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}

ingress {
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
}
egress {
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_instance" "web" {
	ami = "ami-0c02fb55956c7d316"
	instance_type = "t2.micro"
	security_groups = [aws_security_group.web_sg.name]
tags = {
	Name= "application_server"
	Environment = "dev"
}
}

resource "aws_db_instance" "mysql" {
	allocated_storage = 20
	storage_type = "gp2"
	instance_class = "db.t3.micro"
	identifier = "rdstf"
	engine="mysql"
	engine_version = "8.0.27"
	username = "admin"
	password = "password123"
	publicly_accessible = true
	skip_final_snapshot = true
	tags = {
		Name = "myRDS"
	}
}