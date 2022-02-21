resource "aws_route_table" "IGW_route_table" {
  depends_on = [
    aws_internet_gateway.gw
  ]

  vpc_id = aws_vpc.new_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "IGW-route-table"
  }
}

# associate route table to public subnet
resource "aws_route_table_association" "associate_routetable_to_public_subnet" {
  count = "${length(data.aws_availability_zones.available.names)}"
  depends_on = [
    aws_subnet.public_subnet,
    aws_route_table.IGW_route_table,
  ]
  # subnet_id      = aws_subnet.public_subnet.*.id
  subnet_id      = element(split(",", join(",", aws_subnet.public_subnet.*.id)), count.index)
  # subnet_id = aws_subnet.public_subnet.id 
  route_table_id = aws_route_table.IGW_route_table.id
}