resource "aws_instance" "ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.ec2_type
  key_name = "fortf"
  subnet_id = aws_subnet.Publicsubnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_tls.id]



  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./fortf.pem")
    host     = self.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1",
      "sudo systemctl start nginx"
    ]
  }

  
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.myvpc.id 


  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

}

/*
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.allow_tls.id
  network_interface_id = aws_instance.ec2.primary_network_interface_id
}
*/

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "name" = "myTerraformvpc"
  }
  
}

resource "aws_subnet" "Publicsubnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  

  tags = {
    Name = "PublicSubnet"
  }
  
}


resource "aws_subnet" "Privatesubnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
 

   tags = {
    Name = "PrivateSubnet"
  }
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

   tags = {
    Name = "InternetGateway"
  }
  
  }

  
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.myvpc.id

}


resource "aws_route" "rut" {
  route_table_id = aws_route_table.rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
  
}


resource "aws_route_table_association" "publicroute" {
  subnet_id = aws_subnet.Publicsubnet.id
  route_table_id = aws_route_table.rtb.id

  
}
