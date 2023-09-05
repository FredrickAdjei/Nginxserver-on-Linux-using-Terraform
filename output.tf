output "ec2instanceip" {
    description = "ec2 public ip"
    value = aws_instance.ec2.public_ip
  
}

output "vpcid" {
    description = "id of the vpc"
    value = aws_vpc.myvpc.id
  
}