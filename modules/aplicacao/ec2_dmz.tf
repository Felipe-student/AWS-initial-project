resource "aws_instance" "ec2_1" {
  ami = "ami-0360c520857e3138f"
  instance_type = var.instance_type
  subnet_id = aws_subnet.dmz.id
  vpc_security_group_ids = [aws_security_group.dmz]
  tags = {
    Name = "ec2-dmz"
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