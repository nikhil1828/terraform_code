# provider "aws" {
#   region  = "ap-southeast-1"
#   profile = "dev"
# }

# resource "aws_db_instance" "database-1" {
#   allocated_storage    = 20
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
#   name                 = "mydb"
#   username             = "admin"
#   password             = "zxcvbnm123"
#   availability_zone = "ap-southeast-1a"
#   parameter_group_name = "default.mysql5.7"
#   skip_final_snapshot  = true
# }


resource "aws_db_instance" "database13" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "admin"
  password             = "zxcvbnm123"
  availability_zone = "ap-southeast-1a"
  db_subnet_group_name = aws_db_subnet_group.mydb-snetgrp.name
  vpc_security_group_ids = [var.rds-sg-id]
  # parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}


resource "aws_db_subnet_group" "mydb-snetgrp" {
  name       = "mydb-snet"
  subnet_ids = [var.rds-subnet1,var.rds-subnet2]

  tags = {
    Name = "My DB subnet group"
  }
}

