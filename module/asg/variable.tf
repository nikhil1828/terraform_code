
//LAUNCH CONFIGURATION
variable "lc_name" {}

variable "image_id" {}

variable "instance_type" {}

variable "key_name" {}

variable "sg" {}

//AUTO SCALING
variable "asg_name" {}

variable "asg_name2" {}

variable "min-size" {}

variable "max-size" {}

variable "desired_capacity" {}

variable "snet" {
   # type = map
}

variable "snet2" {
   # type = map
}

variable "tg-arn" {}

variable "tg2-arn" {}

variable "grace_period" {}

variable "hc_type" {}
