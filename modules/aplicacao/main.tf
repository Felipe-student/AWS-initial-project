resource "aws_instance" "ec2_1" {
  ami = "ami-0360c520857e3138f"
  instance_type = var.instance_type
  subnet_id = aws_subnet.dmz.id
  vpc_security_group_ids = [aws_security_group.dmz]
  tags = {
    Name = "ec2-dmz"
  }
}

resource "aws_instance" "ec2_2" {
    ami = "ami-0360c520857e3138f"
    instance_type = var.instance_type
    subnet_id = aws_subnet.bd.id
    vpc_security_group_ids = [aws_security_group.app]

    tags = {
        Name = "ec2-bd"
    }
}

resource "aws_instance" "ec2_3"{
    ami = "ami-0f9c6511313201a5b"
    instance_type = var.instance_type
    subnet_id = var.subnet_app_id
    vpc_security_group_ids = [aws_security_group.bd]

    tags = {
        Name = "ec2-app"
    }
}

resource "aws_security_group" "dmz" {
  name = "dmz-security-group"
  vpc_id = var.vpc_id
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
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "app-ssh" {
  security_group_id = aws_security_group.app.id
  from_port = aws_security_group.dmz.id
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "app-rdp" {
  security_group_id = aws_security_group.app.id
  from_port = 3389
  ip_protocol = "tcp"
  to_port = 3389
}

resource "aws_vpc_security_group_egress_rule" "app-saida" {
  security_group_id = aws_security_group.app.id
  cidr_ipv4  = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "bd" {
  name = "bd-security-group"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "bd-linux" {
  security_group_id = aws_security_group.bd.id
  from_port = aws_security_group.app.id
  ip_protocol = "tcp"
  to_port = 12555
}

resource "aws_vpc_security_group_egress_rule" "bd-saida" {
  security_group_id = aws_security_group.bd.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}