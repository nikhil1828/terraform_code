
# variable "total-ec2" {}

//TARGET GROUP 
variable "tg-name" {}


# variable "target_type" {}

variable tg_vpc {}

//APPLICATION LOAD BALANCER
variable "lb_name" {}

variable "internal" {}

variable "ip_type" {}

variable "sg" {}

# variable "pub_snet" {}

# variable "pub_snet2" {}

variable "ec2_id" {
  type = map
}

//LISTENER FOR ELB
variable "action-type" {}

variable "sub-id" {
  type = map
}