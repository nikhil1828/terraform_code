//TARGET GROUP FOR LB//
resource "aws_lb_target_group" "web-tg" {
  name     = var.tg-name
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = var.tg_vpc
}


# //TARGET GROUP REGISTERING
# resource "aws_lb_target_group_attachment" "web-tg-attachments" {
#   count = length(var.pub_snet)
#   target_group_arn = aws_lb_target_group.web-tg.arn
#   # target_id        = "${element(aws_instance.web[count.index].id)}"
#   target_id = var.pub_snet[count.index]
#   port             = var.port
# }


//LOAD BALANCER//
resource "aws_lb" "web-ealb" {
  name               = var.lb_name
  internal           = var.internal
  load_balancer_type = "application"
  ip_address_type = var.ip_type
  security_groups    = [var.sg]
  subnets            = var.pub_snet

  tags = {
    Environment = "${terraform.workspace}_LB"
  }
}

//LISTENER OF LB
resource "aws_lb_listener" "web-ealb-to-web-tg" {
  load_balancer_arn = aws_lb.web-ealb.arn
  port              = var.port
  protocol          = var.protocol
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = var.action-type
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

