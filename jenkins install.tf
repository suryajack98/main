terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.8.0"
    }
  }
}

provider "aws" {
    region = "ap-south-1"
}

resource "aws_security_group" "jrnkins2-401_sg" {

    name               = "jenkins2-401"
    description        = "Allow ssh and HTTP traffic"
    vpc_id             = "vpc-0c5d930af2f2e3a47"

   ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

    ingress {
    description      = "TLS from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }   

     ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   } 
   
   tags = {
    Name = "jenkins-sg"
}
}

resource "aws_instance" "jenkins2-401_ec2" {
    ami                                    = "ami-0d13e3e640877b0b9"
    instance_type                          = "t2.micro"
    availability_zone                      = "ap-south-1a"
    key_name                               = "PPK"
    subnet_id                              = "subnet-00ad377c551a7da57"
    vpc_security_group_ids                   = ["sg-05a17dee3a87eaec1"]

    user_data = <<-EOF
       #!/bin/bash
       yum update -y
        wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
        rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
        yum upgrade -y
        yum install java -y
        yum install jenkins -y
        systemctl daemon-reload
        systemctl enable jenkins
        systemctl start jenkins
        EOF

      tags = {
        name = "jenkins"
    }
}


resource "aws_s3_bucket" "jenkins2-401_artifacts20-s3"{
    bucket = "jenkins2-401-artifacts20-s3"

}