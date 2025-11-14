resource "aws_route_table" "dmz_rota" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "dmz-rota"
  }
}

 resource "aws_route_table_association" "dmz_assoc" {
  subnet_id = aws_subnet.dmz.id
  route_table_id = aws_route_table.dmz_rota.id
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
  route_table_id = aws_route_table.app_rota.id
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