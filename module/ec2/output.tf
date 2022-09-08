output "ec2_id" {
  value = {for k ,v in aws_instance.web:k=>v.id}
}

