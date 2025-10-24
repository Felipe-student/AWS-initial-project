data "aws_ami" "ubuntu" {
  most_recent = true
    owners = [099720109477]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu_2" {
  most_recent = true
    owners = [099720109477]
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "windows"{
    most_recent = true
    owners = [801119661308]

    filter{
        name = "windows_server"
        values = ["windows_Server-2022-English-Full-Base-*"]
    }

    filter{
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "ec2_1" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.dmz.id
  vpc_security_group_ids = [aws_security_group.dmz]
  tags = {
    Name = "ec2-dmz"
  }
}

resource "aws_instance" "ec2_2" {
    ami = data.aws_ami.ubuntu_2.id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.bd.id
    vpc_security_group_ids = [aws_security_group.app]

    tags = {
        Name = "ec2-bd"
    }
}

resource "aws_instance" "ec2_3"{
    ami = data.aws_ami.windows.id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.app.id
    vpc_security_group_ids = [aws_security_group.bd]

    tags = {
        Name = "ec2-app"
    }
}

resource "aws_security_group" "dmz" {
  name = "dmz-security-group"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dmz-security"
  }
}

resource "aws_vpc_security_group_ingress_rule" "dmz_ssh" {
  security_group_id = aws_security_group.dmz.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "dmz_saida" {
  security_group_id = aws_security_group.dmz.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "app" {
  name = "app-security-group"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "app-security"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app-ssh" {
  security_group_id = aws_security_group.app.id
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
  referenced_security_group_id = aws_security_group.dmz.id
}

resource "aws_vpc_security_group_ingress_rule" "app-rdp" {
  security_group_id = aws_security_group.app.id
  from_port = 3389
  ip_protocol = "tcp"
  to_port = 3389
  referenced_security_group_id = aws_security_group.dmz.id
}

resource "aws_vpc_security_group_egress_rule" "app-saida" {
  security_group_id = aws_security_group.app.id
  cidr_ipv4  = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "bd" {
  name = "bd-security-group"
  vpc_id = aws_vpc.main.vpc_id

  tags = {
    Name = "bd-security"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bd-linux" {
  security_group_id = aws_security_group.bd.id
  from_port = 12555
  ip_protocol = "tcp"
  to_port = 12555
}

resource "aws_vpc_security_group_egress_rule" "bd-saida" {
  security_group_id = aws_security_group.bd.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}