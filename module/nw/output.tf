# creating vpc output
output "vpc_id"{
    value = aws_vpc.test_vpc.id
} 
 
 output "pub_snetid" {
    value = {for k,v in aws_subnet.pub-snet: k=>v.id}  
   }

