provider "aws" {
  region  = "ap-southeast-1"
  profile = "dev"
}

data "aws_availability_zones" "available" {
  state = "available"
}
module "nw" {
  source = "./module/nw"
  pub_sn_details = {

    "snet-pb-1" ={
      cidr_block = "10.0.0.0/22"
      availability_zone = "ap-southeast-1a"
    },
    "snet-pb-2" ={
      cidr_block = "10.0.4.0/22"
      availability_zone = "ap-southeast-1b"
    }
  }

  pvt_sn_details = {
    "snet-pvt-1" = {
      cidr_block = "10.0.8.0/22"
      availability_zone = "ap-southeast-1a"
    },
    "snet-pvt-2" = {
      cidr_block = "10.0.12.0/22"
      availability_zone = "ap-southeast-1b"
    }
  }
  nat_reqd = true
  pub-snet-name = "snet-pb-1"
}

output "pub-snetid" {
    value = lookup(module.nw.pub_snetid,"snet-pb-1", null).id
  }

module "sg" {
  source = "./module/sg"
  sg_details = {

  "ec2-sg" = {
    name        = "ec2-http/s"
    description = "SG for ec2"
    vpc_id      = module.nw.vpc_id
    ingress_rules = [
      {
        from_port         = 80
        to_port           = 80
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
        self = null
        security_groups = null
      },
      {
        from_port         = 22
        to_port           = 22
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
        self = null
        security_groups = null
      },
      {
        from_port         = 443
        to_port           = 443
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
        self = null
        security_groups = null
      }
    ]
  },
  "lb-sg" = {
    name        = "lb-http/s"
    description = "SG for ELB"
    vpc_id      = module.nw.vpc_id
    ingress_rules = [
      {
        from_port         = 80
        to_port           = 80
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
        self = null
        security_groups = null

      },
      {
        from_port         = 443
        to_port           = 443
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
        self = null
        security_groups = null
      },
      {
        from_port         = 22
        to_port           = 22
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
        self = null
        security_groups = null
      }
    ]
  }
  # "rds-sg" = {
  #   name        = "lb-http/s"
  #   description = "SG for ELB"
  #   vpc_id      = module.nw.vpc_id
  #   ingress_rules = [
  #     {
  #       from_port         = 3306
  #       to_port           = 3306
  #       protocol          = "tcp"
  #       cidr_blocks       = [module.nw.vpc_id]
  #       # security_groups   = ["${aws_security_group.allow_tls.id}"]
  #        security_groups   = [lookup(module.sg.sg_id,"ec2-sg",null)]
  #       # self = null
  #     }
  #   ]
  # }
}
}

module "sg2" {
  source = "./module/sg"
  sg_details = {
  "rds-sg" = {
    name        = "lb-http/s"
    description = "SG for ELB"
    vpc_id      = module.nw.vpc_id
    ingress_rules = [
      {
        from_port         = 3306
        to_port           = 3306
        protocol          = "tcp"
        cidr_blocks       = ["10.0.0.0/20"]
        # security_groups   = ["${aws_security_group.allow_tls.id}"]
         security_groups   = [lookup(module.sg.sg_id,"ec2-sg",null)]
        self = null
      }
    ]
  }
  }
}
 
module "ec2" {
  source = "./module/ec2"
  pub_snet = lookup(module.nw.pub_snetid, "snet-pb-1",null).id
  sg = lookup(module.sg.sg_id,"ec2-sg",null)
  # ami_id = "ami-0706c8237f00ee5cc"
  ami_id = "ami-04ff9e9b51c1f62ca"
  instance_type = "t2.micro"
  key_name = "key_singapore"
  # tg_vpc = module.nw.vpc_id
  rds-subnet1 = lookup(module.nw.pub_snetid, "snet-pb-1" ,null).id
  rds-subnet2 = lookup(module.nw.pub_snetid, "snet-pb-2" ,null).id
}

# module "lb" {
#   source ="./module/lb"
#   pub_snet = module.nw.pub_snetid
#   sg = lookup(module.sg.sg_id,"lb-sg",null)
#   tg_vpc = module.nw.vpc_id
#   # total-ec2 = module.ec2.no-of-ec2
#   tg-name = "ec2-tg-grp"
#   port = 80
#   protocol = "HTTP"
#   target_type = "instance"
#   lb_name = "ec2-ealb"
#   internal = false
#   lb_type = "application"
#   ip_type = "ipv4"
#   action-type = "forward"
# }


# module "asg" {
#   source = "./module/asg"
#   lc_name = "web_config"
#   image_id = "ami-0706c8237f00ee5cc"
#   instance_type = "t2.micro"
#   key_name = "key_singapore"
#   sg = lookup(module.sg.sg_id,"lb-sg",null)
#   asg_name = "terraform-asg-example"
#   min-size = 2
#   max-size = 4
#   desired_capacity = 3
#   pub_snet = module.nw.pub_snetid
#   tg-arn = module.lb.tg-arn
#   grace_period = 300
#   hc_type = "ELB"
# }

# # element(module.nw.pub_snetid,1)

# output "pb-snet-ids" {
#   value = module.nw.pub_snetid
# }

module "test" {
  source = "./test"
}
# output "join-test" {
#   value = module.test.join-fn
# }

# output "chomp-fn-1" {
#   value = module.test.chomp-fn
# }

# output "substr" {
#  value = module.test.substr-test 
# }

# output "trimfn" {
#  value = module.test.split-test 
# }

# output "chunk-list" {
#  value = module.test.chunk
# }

# output "colesce-test" {
#   value = module.test.coelesce
# }

# output "contains-test" {
#   value = module.test.contains
# }

# output "tolist-test" {
#   value = module.test.tolist
# }