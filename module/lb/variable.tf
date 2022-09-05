
# variable "total-ec2" {}

//TARGET GROUP 
variable "tg-name" {}

# variable "port" {}

# variable "protocol" {}

# variable "target_type" {}

variable tg_vpc {}

//APPLICATION LOAD BALANCER
variable "lb_name" {}

variable "internal" {}

# variable "lb_type" {}

variable "ip_type" {}

variable "sg" {}

variable "pub_snet" {}

//LISTENER FOR ELB
variable "action-type" {}