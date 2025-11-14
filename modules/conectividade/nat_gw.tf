
resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.app.id
    
    depends_on = [ aws_internet_gateway.igw ]
}