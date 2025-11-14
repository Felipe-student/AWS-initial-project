resource "aws_instance" "ec2_2" {
    ami = "ami-0360c520857e3138f"
    instance_type = var.instance_type
    subnet_id = aws_subnet.bd.id
    vpc_security_group_ids = [aws_security_group.app]

    tags = {
        Name = "ec2-bd"
    }
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

