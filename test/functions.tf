# module "test" {
#   source = "./test"
# }


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

# output "pb-snet-ids" {
#   value = module.nw.pub_snetid
# }

module "nw" {
  source = "../module/nw"
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

output "vpc" {
  value = module.nw.vpc_id.id
}

output "pub-snetid" {
    value = {id1 = lookup(module.nw.pub_snetid,"snet-pb-1", null), id2= lookup(module.nw.pub_snetid,"snet-pb-2", null)}
  }