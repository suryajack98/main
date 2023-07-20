# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.8"
#     }
#   }
# }
# # Configure the AWS Provider
# provider "aws" {
#   region = "ap-south-1"
# }

# #VPC

# resource "aws_vpc" "myvpc" {
#   cidr_block       = "10.0.0.0/16"
#   instance_tenancy = "default"

#   tags = {
#     Name = "MY-VPC"
#   }
# }

# #Public subnet

# resource "aws_subnet" "pubsub" {
#   vpc_id     = aws_vpc.myvpc.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "Public Subnet"
#   }
# }

# #private subnet

# resource "aws_subnet" "prisub" {
#   vpc_id     = aws_vpc.myvpc.id
#   cidr_block = "10.0.2.0/24"

#   tags = {
#     Name = "Private Subnet"
#   }
# }

# #Internet Gateway

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.myvpc.id

#   tags = {
#     Name = "MyIGW"
#   }
# }

# #public Routetable

# resource "aws_route_table" "pubrt" {
#   vpc_id = aws_vpc.myvpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
#   tags = {
#     Name = "Public Route table"
#   }
# }

# #public Route table association

# resource "aws_route_table_association" "pubrta" {
#   subnet_id      = aws_subnet.pubsub.id
#   route_table_id = aws_route_table.pubrt.id
# }

# #EIP

# resource "aws_eip" "eip" {
  
#   vpc      = true
#   tags = {
#     Name = "MyEIP"
#   }
# }

# #NAT

# resource "aws_nat_gateway" "mynat" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = aws_subnet.pubsub.id

#   tags = {
#     Name = "gw NAT"
#   }
# }
# #Private Route Table

# resource "aws_route_table" "prirt" {
#   vpc_id = aws_vpc.myvpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
#   tags = {
#     Name = "Private Route table"
#   }
# }

# resource "aws_security_group" "pubsg" {
#   name        = "pubsg"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = aws_vpc.myvpc.id

#   ingress {
#     description      = "TLS from VPC"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
    
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
    
#   }

#   tags = {
#     Name = "Public security group"
#   }
# }

# resource "aws_security_group" "prisg" {
#   name        = "allow_tls"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = aws_vpc.myvpc.id

#   ingress {
#     description      = "TLS from VPC"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["10.0.1.0/24"]
    
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
    
#   }

#   tags = {
#     Name = "Private security group"
#   }
# }

# resource "aws_instance" "pub_instance" {
#   ami                                    = "ami-006935d9a6773e4ec"
#   instance_type                          = "t2.micro"
#   availability_zone                      = "ap-south-1b"
#   associate_public_ip_address            = "true"
#   vpc_security_group_ids                 = [aws_security_group.pubsg.id]
#   subnet_id                              = aws_subnet.pubsub.id 
#   key_name                               = "PPK"
  
#     tags = {
#     Name = "HDFCBANK WEBSERVER"
#   }
# }

# resource "aws_instance" "pri_instance" {
#   ami                                    = "ami-006935d9a6773e4ec"
#   instance_type                          = "t2.micro"
#   availability_zone                      = "ap-south-1b"
#   associate_public_ip_address            = "false"
#   vpc_security_group_ids                 = [aws_security_group.prisg.id]
#   subnet_id                              = aws_subnet.prisub.id 
#   key_name                               = "PPK"
  
#     tags = {
#     Name = "HDFCBANK APPSERVER"
#   }
# }