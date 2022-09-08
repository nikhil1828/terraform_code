
# resource "aws_iam_role" "s3-role-ec2" {
#   name = "s3_fulle_access"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })

#   tags = {
#     tag-key = "tag-value"
#   }
# }

# resource "aws_iam_policy" "s3-full-acs-policy" {
#   name        = "test_policy"
#   path        = "/"
#   description = "My test policy"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode(
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:*",
#                 "s3-object-lambda:*"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
#   )
# }

# resource "aws_iam_policy_attachment" "test-attach" {
#   name       = "test-attachment"
#   roles       = [aws_iam_role.s3-role-ec2.name]
#   policy_arn = aws_iam_policy.s3-full-acs-policy.arn
# }

# resource "aws_iam_instance_profile" "test_profile" {
#   name = "test_profile"
#   role = aws_iam_role.s3-role-ec2.name
# }

//INSTANCE LAUNCHING//

# data "template_file" "wpconfig"{
#   template = file("files/wp-config.php")

#   vars = {
#     db_host = aws_db_instance.database13.address
#     db_user = var.username
#     db_pass = var.password
#     db_name = var.dbname
#   }
# }

# data "template_file" "nginx" {
#   template = file("files/default")
# }

resource "aws_instance" "web" {
  # count = length(var.pub_snet)
  for_each = var.ec2_sub
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = [var.sg]
  subnet_id = each.value["pub-snet"]
  # iam_instance_profile = aws_iam_instance_profile.test_profile.name
  user_data = <<-EOF
  #!/bin/bash
  sudo su -
  apt update -y
  apt install nginx -y
  apt install mysql-server -y
  apt install php-fpm -y
  apt install php-mysql -y
  apt install awscli -y
  cd /var/www/html
  wget http://wordpress.org/latest.tar.gz
  tar xzvf latest.tar.gz

  EOF
  tags = {
    Name = "${terraform.workspace}_ec2"
  }

#   provisioner "file" {
#   content = data.template_file.wpconfig.rendered
#   destination = "/tmp/wp-config.php"

#   connection {
#     type = "ssh"
#     user = "ubuntu"
#     host = self.public_ip
#     private_key = file(var.ssh_pvt_key)
#   }
# }

# provisioner "remote-exec" {
#   inline = [
#     "sleep 250 && sudo cp /tmp/wp-config.php /var/www/html/wordpress/wp-config.php"
#   ]
#   connection {
#     type = "ssh"
#     user = "ubuntu"
#     host = self.public_ip
#     private_key = file(var.ssh_pvt_key)
#   }
# }

# provisioner "file" {
#   content = data.template_file.nginx.rendered
#   destination = "/tmp/default"

#   connection {
#     type = "ssh"
#     user = "ubuntu"
#     host = self.public_ip
#     private_key = file(var.ssh_pvt_key)
#   }
# }

# provisioner "remote-exec" {
#   inline = [
#     "sudo cp /tmp/default /etc/nginx/sites-enabled/default"
#   ]
#   connection {
#     type = "ssh"
#     user = "ubuntu"
#     host = self.public_ip
#     private_key = file(var.ssh_pvt_key)
#   }
# }

}

# resource "aws_db_instance" "database13" {
#   allocated_storage    = 20
#   engine               = "mysql"
#   engine_version       = "8.0"
#   instance_class       = "db.t3.micro"
#   db_name              = "mydb"
#   username             = "admin"
#   password             = "zxcvbnm123"
#   availability_zone = "ap-southeast-1a"
#   db_subnet_group_name = aws_db_subnet_group.mydb-snetgrp.name
#   vpc_security_group_ids = [var.rds-sg-id]
#   # parameter_group_name = "default.mysql5.7"
#   skip_final_snapshot  = true
# }

# resource "aws_db_subnet_group" "mydb-snetgrp" {
#   name       = "mydb-snet"
#   subnet_ids = [var.rds-subnet1,var.rds-subnet2]

#   tags = {
#     Name = "My DB subnet group"
#   }
# }

