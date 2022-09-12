
# variable "total-ec2" {}

//TARGET GROUP 
variable "tg-name" {}

variable "tg-name2" {}

# variable "target_type" {}

variable tg_vpc {}

//APPLICATION LOAD BALANCER
variable "lb_name" {}

variable "lb_name2" {}

variable "internal" {}

variable "internal2" {}

variable "ip_type" {}

variable "sg" {}

# variable "pub_snet" {}

# variable "pub_snet2" {}

# variable "ec2_id" {
#   type = map
# }

//LISTENER FOR ELB
variable "action-type" {}

variable "sub-id" {
  type = map
}

variable "sub2-id" {
  type = map
}