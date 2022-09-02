//join function 
# variable "join" {
#   default = ["H", "c","t"]
# }
# output "join-fn" {
#     value = "${join("",var.join)}"
  
# }


# variable "chomp-var" {
#   default = "nik\nhil\n"
# }
# output "chomp-fn" {
#     value = "${chomp(var.chomp-var)}"
# }

# variable "string" {
#   default = "NIKHILnikhil"
# }

# output "substr-test" {
#   value = "${substr(var.string,-1,0)}"
# }

# variable "string" {
#   default = "this@isn||tit"
# }

# output "trim-test" {
#   value = "${trimspace(var.string)}"
# }

# output "split-test" {
#   value = "${split ("-" , var.string)}"
# }

# variable "string" {
#   default = ["H", "c","t","d","f","w","v"]
# }

# output "chunk" {
#   value = "${chunklist(var.string,3)}"
# }

# variable "args" {
#   default = ["1","2","3","4","5"]
# }

# output "coelesce" {
#   value = "${coalesce(["1","2","3","4","5"])}"
# }

# output "contains" {
#   value = contains(var.args,"8")
# }

# output "tolist" {
#   value = tolist( "2" ,"8" ,"3" ,"0" ,"2" ,"dv" )
# }
