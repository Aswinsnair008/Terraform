#public subnet
resource "aws_subnet" "public_subnet" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id     = aws_vpc.new_vpc.id
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index +1) }"
  # cidr_block = "10.0.1.0/24"
  # availability_zone = "${element(var.azs,count.index) }"
  availability_zone = "${(data.aws_availability_zones.available.names [count.index])}"
  

  tags = {
    Name = "public-subnet-${count.index}"
  }
   map_public_ip_on_launch = true
}
#private subnet
# resource "aws_subnet" "private_subnet" {
#   vpc_id     = aws_vpc.new_vpc.id
#   cidr_block = "10.0.5.0/24"

#   tags = {
#     Name = "private-subnet"
#   }
# }

#bucket for version control
terraform {
  backend "s3" {
    bucket = "terraform1234566"
    key    = "devopstest/terraform.tfstate"
    region = "ap-south-1"
  }
}


