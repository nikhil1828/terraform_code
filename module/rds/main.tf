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