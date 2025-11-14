resource "aws_instance" "ec2_2" {
    ami = "ami-0360c520857e3138f"
    instance_type = var.instance_type
    subnet_id = aws_subnet.bd.id
    vpc_security_group_ids = [aws_security_group.app]

    tags = {
        Name = "ec2-bd"
    }
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
