terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
}


provider "aws" {
  region = "us-west-2"
  secret_key = "${var.secret_key}"
  access_key = "${var.access_key}"
}


resource "aws_vpc" "upc-vpc-1" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "upc-vpc-1"
    }
}

resource "aws_internet_gateway" "upc-internet-gateway-1" {
    vpc_id = "${aws_vpc.upc-vpc-1.id}"
    tags = {
      Name = "upc-internet-gateway-1"
    }
}

resource "aws_route_table" "upc-route-table-1" {
    vpc_id = "${aws_vpc.upc-vpc-1.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.upc-internet-gateway-1.id}"
    }

    tags = {
      Name = "upc-route-table-1"
    }
}


resource "aws_subnet" "aws-subnet-1" {
    vpc_id = aws_vpc.upc-vpc-1.id
    availability_zone = "us-west-2a"
    cidr_block = "10.0.10.0/24"
    tags = {
        Name = "aws-subnet-1"
    }
}

resource "aws_subnet" "aws-subnet-2" {
    vpc_id = aws_vpc.upc-vpc-1.id
    availability_zone = "us-west-2b"
    cidr_block = "10.0.20.0/24"
    tags = {
        Name = "aws-subnet-2"
    }
}

resource "aws_route_table_association" "upc-route-table-association-1" {
  subnet_id = aws_subnet.aws-subnet-1.id
  route_table_id = aws_route_table.upc-route-table-1.id
}

resource "aws_route_table_association" "upc-route-table-association-2" {
    subnet_id = aws_subnet.aws-subnet-2.id
    route_table_id = aws_route_table.upc-route-table-1.id
}


resource "aws_instance" "upc-ec2-instance-1" {
    ami = "ami-023e152801ee4846a"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.aws-subnet-1.id}"
    tags = {
        Name = "upc-ec2-instance-1"
    }
  
}

resource "aws_instance" "upc-ec2-instance-2" {
    ami = "ami-023e152801ee4846a"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.aws-subnet-2.id}"
    tags = {
        Name = "upc-ec2-instance-2"
    }
  
}





 



