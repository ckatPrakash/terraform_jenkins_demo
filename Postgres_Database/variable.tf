variable "db_host" {
	default  = "aws_db_instance.postgresql.address"
}

variable "db_port" {
	default = 5432
}

variable "db_user" {
 default = "postgres"
}

variable "db_password" {
	default = "postgres"
}

variable "db_name" {
	default = "myappdb"
}
