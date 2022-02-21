data "aws_ami" "ubuntu" {
  most_recent = true
  

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  count = 1
  ami           = data.aws_ami.ubuntu.id
  # subnet_id      = element(split(",", join(",", aws_subnet.public_subnet.*.id)))
  subnet_id = "${element(split(",", join(",", aws_subnet.public_subnet.*.id)), count.index)}"
#   security_group_id = aws_security_group.allow_icmp.id
  
#   route_table_id = aws_route_table.bar.id
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("./test")
    host     = self.public_ip
  }
  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
    
  }
#to execute in remote machine
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh args",
    ]
    
  }
#to run in local-machine
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ip.txt" #here we are copying the IP address details to local
    
  }

  tags = {
    Name = "terraform_test"
  }
}
