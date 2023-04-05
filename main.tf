# Tenacity network configuration 

resource "aws_vpc" "Tenacity-VPC" {
  cidr_block       = var.Vpc_cidr

  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Tenacity_VPC"
  }
}
# Creating Public Subnets
resource "aws_subnet" "Prod-pub-sub1" {
  vpc_id            = aws_vpc.Tenacity-VPC.id
  cidr_block        = var.Prod-pub-sub1

  tags = {
    Name = "Prod-pub-sub1"

  }
}

resource "aws_subnet" "Prod-pub-sub2" {
  vpc_id            = aws_vpc.Tenacity-VPC.id
  cidr_block        = var.Prod-pub-sub2
  tags = {
    Name = "Prod-pub-sub2"
  }
}

# Creating Private Subnets

resource "aws_subnet" "Prod-priv-sub1" {
  vpc_id     = aws_vpc.Tenacity-VPC.id
  cidr_block = var.Prod-priv-sub1

  tags = {
    Name = "Prod-priv-sub1"
  }
}

resource "aws_subnet" "Prod-priv-sub2" {
  vpc_id     = aws_vpc.Tenacity-VPC.id
  cidr_block = var.Prod-priv-sub2

  tags = {
    Name = "Prod-priv-sub2"
  }
}

# Creating public route table

resource "aws_route_table" "Prod-pub-RT" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  tags = {
    Name = "Prod-pub-RT"
  }
}

# Creating Private Route Table

resource "aws_route_table" "Prod-priv-RT" {
  vpc_id = aws_vpc.Tenacity-VPC.id

  tags = {
    Name = "Prod-priv-RT"
  }
}

# Subnets and RT associations

resource "aws_route_table_association" "pub-route-assoc" {
  subnet_id      = aws_subnet.Prod-pub-sub1.id
  route_table_id = aws_route_table.Prod-pub-RT.id
}

resource "aws_route_table_association" "public-route-assoc1" {
  subnet_id      = aws_subnet.Prod-pub-sub2.id
  route_table_id = aws_route_table.Prod-pub-RT.id
}

resource "aws_route_table_association" "private-route-assoc" {
  subnet_id      = aws_subnet.Prod-priv-sub1.id
  route_table_id = aws_route_table.Prod-priv-RT.id
}

resource "aws_route_table_association" "private-route-assoc1" {
  subnet_id      = aws_subnet.Prod-priv-sub2.id
  route_table_id = aws_route_table.Prod-priv-RT.id
}


# Creation of internet Gateway

#Creating internet IGW
resource "aws_internet_gateway" "t-igw" {
  vpc_id = aws_vpc.Tenacity-VPC.id
  tags = {
    Name = "t-igw"
  }
}
#Public route table n IGW Assocition
resource "aws_route_table" "Prod-pub-RT3" {
  vpc_id = aws_vpc.Tenacity-VPC.id
  route {

    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.t-igw.id

  }
}

# Public Route table and Internet Gateway Association

resource "aws_route_table_association" "Prod-IGW-assoc" {
  gateway_id     = aws_internet_gateway.t-igw.id
  route_table_id = aws_route_table.Prod-pub-RT.id
}

# security group

resource "aws_security_group" "T-SG" {
  name        = "T-SG"
  description = "HTTP and SSH"
  vpc_id      = aws_vpc.Tenacity-VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#2 EC2 kp sg ssh http  
resource "aws_instance" "ROCK_SERVER_1" {
  ami                         = var.ami
  instance_type               = var.Instance_type
  subnet_id                   = aws_subnet.Prod-pub-sub1.id
  security_groups             = [aws_security_group.T-SG.id]
  associate_public_ip_address = true

  tags = {
    "Name" = "Public server1"
  }

}
resource "aws_instance" "ROCK_SERVER_2" {
  ami             = var.ami
  instance_type   = var.Instance_type
  subnet_id       = aws_subnet.Prod-priv-sub2.id
  security_groups = [aws_security_group.T-SG.id]
  

  tags = {
    "Name" = "private server"
  }

}