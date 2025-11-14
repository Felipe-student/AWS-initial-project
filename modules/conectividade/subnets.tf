resource "aws_subnet" "dmz" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/26"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"

    tags = {
        Name = "subnet-dmz-us-east-1a"
    }
}

resource "aws_subnet" "app" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.64/26"
    availability_zone = "us-east-1b"

    tags = {
      Name = "subnet-app-us-east-1b"
    }
}

resource "aws_subnet" "bd" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.128/26"
    availability_zone = "us-east-1c"

    tags = {
        Name = "subnet-bd-us-east-1c"
    }
}