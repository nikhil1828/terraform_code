resource "aws_launch_configuration" "as_conf" {
  name_prefix          = var.lc_name
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = var.sg
  user_data = <<-EOF
  #!/bin/bash
  sudo su -
  apt update -y
  apt install nginx -y
  systemctl restart nginx.service
  EOF
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "bar" {
  name_prefix          = var.asg_name
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = var.min-size
  desired_capacity     = var.desired_capacity
  max_size             = var.max-size
  vpc_zone_identifier = var.snet
  target_group_arns = [var.tg-arn]
  health_check_grace_period = var.grace_period
  health_check_type         = var.hc_type
  
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "bar2" {
  name_prefix          = var.asg_name2
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = var.min-size
  desired_capacity     = var.desired_capacity
  max_size             = var.max-size
  vpc_zone_identifier = [for k in var.snet2: k.snetid]
  target_group_arns = [var.tg2-arn]
  health_check_grace_period = var.grace_period
  health_check_type         = var.hc_type
  
  lifecycle {
    create_before_destroy = true
  }
}