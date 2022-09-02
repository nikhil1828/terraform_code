# Decalring VPC CIDR
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/20"
}

#declaring variable for pub cidr
# variable "pubcidr" {
#     type = list
#     default = ["10.0.0.0/22","10.0.8.0/22"]
# }

variable "pub_sn_details" {
  type = map(object({
    cidr_block = string
    availability_zone = string
  }))
}


#declaring variable for pri cidr
# variable "pricidr" {
#     type = list
#     default = ["10.0.4.0/22","10.0.12.0/22"]
  
# }

variable "pvt_sn_details" {
  type = map(object({
    cidr_block = string
    availability_zone = string
  }))
}

# variable "pri-ip-add" {
#     type = list
#     default = ["10.0.4.22/22"]
  
# }

variable "pub-snet-name" {}


variable "nat_reqd" {}

