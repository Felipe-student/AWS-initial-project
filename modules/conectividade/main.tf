provider aws {
    region = us-esat-1
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/24"
    enable_dns_hostnames = true
}

resource "aws_subnet" "dmz" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/26"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "app" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.64/26"
}

resource "aws_subnet" "bd" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.128/26"
}

resource "aws_eip" "nat" {
    domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.dmz
}

