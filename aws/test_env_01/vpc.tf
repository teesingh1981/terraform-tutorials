# CREATE VPC 
resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "test-vpc"
  }
}

# CREATE PUBLIC SUBNET 
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "Public Subnet"
  }
}

# CREATE IGW 
resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

# CREATE ROUTE TABLE 
resource "aws_route_table" "my_vpc_eu_west_2a_public" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_vpc_igw.id
    }
    tags = {
        Name = "Public Subnet Route Table."
    }
}

# LINK ROUTE TABLE TO SUBNET
resource "aws_route_table_association" "my_vpc_eu_west_2a_public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.my_vpc_eu_west_2a_public.id
}

# CREATE SECURITY GROUP 
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_sg"
  description = "Allow SSH inbound connections"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh_sg"
  }
}

# CREATE EC2 INSTANCE 
resource "aws_instance" "my_instance" {
  ami           = "ami-09744628bed84e434"
  instance_type = "t2.micro"
  key_name = "prom"
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  tags = {
    Name = "testnstance"
  }
}

# OUTPUT IP ADDRESS 
output "instance_public_ip" {
  value = "${aws_instance.my_instance.public_ip}"
}

# SSH CMD
output "ec2_command" {
  value = "ssh -i prom.pem ubuntu@ec2-52-56-195-196.eu-west-2.compute.amazonaws.com"
}
