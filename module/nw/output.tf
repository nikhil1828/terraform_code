# creating vpc output
output "vpc_id"{
    value = aws_vpc.test_vpc.id
} 
 
 output "pub_snetid" {
    value = aws_subnet.pub-snet
}
 