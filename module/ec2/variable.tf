variable "ami_id" {}

variable "instance_type" {}

variable "key_name" {}

variable "pub_snet" {}

variable "sg" {}

# //ELASTIC LOAD BALANCER///

# //TARGET GROUP 
# variable "tg-name" {
#   default = "ec2-tg-grp"
# }
# variable "port" {
#   default = 80
# }
# variable "protocol" {
#   default = "HTTP"
# }
# variable "target_type" {
#   default = "instance"
# }

# variable tg_vpc {}

# //APPLICATION LOAD BALANCER
# variable "lb_name" {
#   default = "ec2-ealb"
# }

# variable "internal" {
#   default = false
# }

# variable "lb_type" {
#   default = "application"
# }
# variable "ip_type" {
#   default = "ipv4"
# }