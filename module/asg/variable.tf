
//LAUNCH CONFIGURATION
variable "lc_name" {}

variable "image_id" {}

variable "instance_type" {}

variable "key_name" {}

variable "sg" {}

//AUTO SCALING
variable "asg_name" {}

variable "min-size" {}

variable "max-size" {}

variable "desired_capacity" {}

variable "pub_snet" {}

variable "tg-arn" {}

variable "grace_period" {}

variable "hc_type" {}
