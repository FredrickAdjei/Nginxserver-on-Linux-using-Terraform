/*
variable "vpn_ip" {
    default = "111.50.39.20/32"
  
}


variable "instancetype" {
    type = string
}

variable "usernumber" {
    type = number
}

variable "elbname" {
    type = string
}

variable "az" {
    type = list
}
*/

variable "ec2_type" {
    description = "ec2 instance type"
    type = string
    default = "t2.micro"
  
}

locals {
  inbound_ports = [22,80,443]
  outbound_ports = [22,80,443]

}