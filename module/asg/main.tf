resource "aws_launch_configuration" "as_conf" {
  name          = var.lc_name
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = [var.sg]
}


resource "aws_autoscaling_group" "bar" {
  name_prefix          = var.asg_name
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = var.min-size
  desired_capacity     = var.desired_capacity
  max_size             = var.max-size
  vpc_zone_identifier = var.pub_snet
  target_group_arns = [var.tg-arn]
  health_check_grace_period = var.grace_period
  health_check_type         = var.hc_type
  
  lifecycle {
    create_before_destroy = true
  }
}

