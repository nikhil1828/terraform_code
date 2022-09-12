output "tg-arn" {
  value = aws_lb_target_group.web-tg.arn
}

output "tg2-arn" {
  value = aws_lb_target_group.web-tg2.arn
}