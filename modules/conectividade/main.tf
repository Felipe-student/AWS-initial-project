provider aws {
    region = us-east-1
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/24"
    enable_dns_hostnames = true
}

resource "aws_subnet" "dmz" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/26"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "app" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.64/26"
    availability_zone = "us-east-1b"
}

resource "aws_subnet" "bd" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.128/26"
    availability_zone = "us-east-1c"
}

resource "aws_eip" "nat" {
    domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.dmz.id
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "dmz_rota" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dmz_rota.id
  }
  tags = {
    Name = "dmz-rota"
  }
}

resource "aws_route_table_association" "dmz_assoc" {
  subnet_id = aws_subnet.dmz.id
  route_table_id = aws_route_table.dmz_rota
}

resource "aws_route_table" "app_rota" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "app-rota"
  }
}

resource "aws_route_table_association" "app_assoc" {
  subnet_id = aws_subnet.app.id
  route_table_id = aws_route_table.app_rota
}

resource "aws_route_table" "bd_rota" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "bd-rota"
  }
}

resource "aws_route_table_association" "bd_assoc" {
  subnet_id = aws_subnet.bd.id
  route_table_id = aws_route_table.bd_rota.id
}