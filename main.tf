provider "aws" {
  region  = "ap-southeast-1"
}

# data "aws_availability_zones" "available" {
#   state = "available"
# }

terraform {
  backend "s3" {
    bucket = "mybktm001"
    key    = "terraform/backend/terraform.tfstate"
    region = "ap-south-1"
  }
}

module "nw" {
  source = "./module/nw"
  vpc_cidr = "10.0.0.0/20"
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

output "vpcid" {
  value = module.nw.vpc_id
}
output "pub-snetid" {
    value = {id1 = lookup(module.nw.pub_snetid,"snet-pb-1", null).id, id2= lookup(module.nw.pub_snetid,"snet-pb-2", null).id}
  }

# output "pub_snetid" {
#   value = module.nw.ec2_id
# }

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
    name        = "lb_http/s"
    description = "SG for ELB"
    vpc_id      = module.nw.vpc_id
    ingress_rules = [
      {
        from_port         = 3306
        to_port           = 3306
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
        # security_groups   = ["${aws_security_group.allow_tls.id}"]
         security_groups   = [lookup(module.sg.sg_id,"ec2-sg",null)]
        self = null
      }
    ]
  }
  }
}
 
# # module "ec2" {
# #   source = "./module/ec2"
# #   pub_snet = lookup(module.nw.pub_snetid, "snet-pb-1",null).id
# #   sg = lookup(module.sg.sg_id,"ec2-sg",null)
# #   # ami_id = "ami-0706c8237f00ee5cc"
# #   ami_id = "ami-04ff9e9b51c1f62ca"
# #   instance_type = "t2.micro"
# #   key_name = "key_singapore"
# #   # tg_vpc = module.nw.vpc_id
# #   rds-subnet1 = lookup(module.nw.pub_snetid, "snet-pb-1" ,null).id
# #   rds-subnet2 = lookup(module.nw.pub_snetid, "snet-pb-2" ,null).id
# #   username = "admin"
# #   password = "zxcvbnm123"
# #   dbname = "mydb"
# #   rds-sg-id = lookup(module.sg2.sg_id,"rds-sg",null)
# # }

# module "ec2" {
#   source = "./module/ec2"
#   ec2_sub = lookup(module.nw.pub_snetid,"snet-pb-1",null).id
#   # ec2_sub = {
#   #   ec2-001 = {
#   #     pub-snet = lookup(module.nw.pub_snetid,"snet-pb-1", null).id
#   #   },
#   #   ec2-002 = {
#   #     pub-snet = lookup(module.nw.pub_snetid,"snet-pb-2", null).id
#   #   }
#   # }
#   sg = [lookup(module.sg.sg_id,"ec2-sg",null)]
#   ami_id = "ami-04ff9e9b51c1f62ca"
#   instance_type = "t2.micro"
#   key_name = "key_singapore"
# }
  
# output "ec2detials" {
#       value = module.ec2.ec2_id
#   }

# module "lb" {
#   source ="./module/lb"
#   pub_snet = lookup(module.nw.pub_snetid,"snet-pb-1",null).id
#   pub_snet2 = lookup(module.nw.pub_snetid,"snet-pb-2",null).id
#   sg = lookup(module.sg.sg_id,"lb-sg",null)
#   tg_vpc = module.nw.vpc_id
#   # total-ec2 = module.ec2.no-of-ec2
#   tg-name = "ec2-tg-grp"
#   ec2_id = module.ec2.no-of-ec2
#   lb_name = "ec2-ealb"
#   internal = false
#   ip_type = "ipv4"
#   action-type = "forward"
# }

module "lb" {
  source ="./module/lb"
  sub-id = {
    lb-sub1 ={
      snetid = lookup(module.nw.pub_snetid,"snet-pb-1",null).id
    },
    lb-sub2 ={
      snetid = lookup(module.nw.pub_snetid,"snet-pb-2",null).id
    }
  }
  sub2-id = {
    lb-sub1 ={
      snetid = lookup(module.nw.pvt_snetid,"snet-pvt-1",null).id
    },
    lb-sub2 ={
      snetid = lookup(module.nw.pvt_snetid,"snet-pvt-2",null).id
    }
  }
  sg = lookup(module.sg.sg_id,"lb-sg",null)
  tg_vpc = module.nw.vpc_id
  tg-name = "ec2-tg1-grp"
  tg-name2 = "ec2-tg2-grp"
  # ec2_id = {
  #   ec2-001 ={
  #     ec2id = lookup(module.ec2.ec2_id, "ec2-001")
  #   },
  #   ec2-002 ={
  #     ec2id = lookup(module.ec2.ec2_id, "ec2-002")
  #   }
  # }
  # ec2_id = module.ec2.ec2_id
  lb_name = "pub-ealb"
  lb_name2 = "pvt-ealb"
  internal = false
  internal2 = true
  ip_type = "ipv4"
  action-type = "forward"
}

# module "lb2" {
#   source ="./module/lb"
#   sub-id = {
#     lb2-sub1 ={
#       snetid = lookup(module.nw.pvt_snetid,"snet-pvt-1",null).id
#     },
#     lb2-sub2 ={
#       snetid = lookup(module.nw.pvt_snetid,"snet-pvt-2",null).id
#     }
#   }
#   sg = lookup(module.sg.sg_id,"lb-sg",null)
#   tg_vpc = module.nw.vpc_id
#   tg-name = "ec2-tg2-grp"
#   # ec2_id = {
#   #   ec2-001 ={
#   #     ec2id = lookup(module.ec2.ec2_id, "ec2-001")
#   #   },
#   #   ec2-002 ={
#   #     ec2id = lookup(module.ec2.ec2_id, "ec2-002")
#   #   }
#   # }
#   # ec2_id = module.ec2.ec2_id
#   lb_name = "pvt-ealb"
#   internal = true
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


module "asg" {
  source = "./module/asg"
  lc_name = "web_config1"
  image_id = "ami-052be32294d30838c"
  instance_type = "t2.micro"
  key_name = "key_singapore"
  sg = [lookup(module.sg.sg_id,"lb-sg",null)]
  asg_name = "terraform-asg1"
  asg_name2 = "terraform-asg2"
  min-size = 1
  max-size = 3
  desired_capacity = 1
  snet = [lookup(module.nw.pub_snetid,"snet-pb-1",null).id, lookup(module.nw.pub_snetid,"snet-pb-2",null).id]
  snet2 = {
    asg-sub1 ={
      snetid = lookup(module.nw.pvt_snetid,"snet-pvt-1",null).id
    },
    asg-sub2 ={
      snetid = lookup(module.nw.pvt_snetid,"snet-pvt-2",null).id
    }
  }
  tg-arn = module.lb.tg-arn
  tg2-arn = module.lb.tg2-arn
  grace_period = 300
  hc_type = "ELB"
}

# module "asg2" {
#   source = "./module/asg"
#   lc_name = "web_config2"
#   image_id = "ami-052be32294d30838c"
#   instance_type = "t2.micro"
#   key_name = "key_singapore"
#   sg = [lookup(module.sg.sg_id,"lb-sg",null)]
#   asg_name = "terraform-asg2"
#   min-size = 1
#   max-size = 3
#   desired_capacity = 2
#   snet = [lookup(module.nw.pvt_snetid,"snet-pvt-1",null).id,lookup(module.nw.pvt_snetid,"snet-pvt-2",null).id]
#   # pub_snet = {
#   #   asg-sub1 ={
#   #     snetid = lookup(module.nw.pub_snetid,"snet-pb-1",null).id
#   #   },
#   #   asg-sub2 ={
#   #     snetid = lookup(module.nw.pub_snetid,"snet-pb-2",null).id
#   #   }
#   # }
#   tg-arn = module.lb2.tg-arn
#   grace_period = 300
#   hc_type = "ELB"
# }

# # element(module.nw.pub_snetid,1)
