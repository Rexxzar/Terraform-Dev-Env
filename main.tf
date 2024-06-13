
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/24"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true #dns support
  tags = {
    Name = "dev"
  }

}
resource "aws_subnet" "mysubnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/25"
  map_public_ip_on_launch = true
  tags = {
    name = "dev-public"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "main-igw"
  }
}
resource "aws_route_table" "myroutetable" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    name = "dev_route_table"
  }
}
resource "aws_route" "defualt-gateaway" {
  route_table_id         = aws_route_table.myroutetable.id
  gateway_id             = aws_internet_gateway.myigw.id
  destination_cidr_block = "0.0.0.0/0"

}
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myroutetable.id

}

resource "aws_security_group" "dev-sec" {
  name        = "dev-sec"
  description = "dev-sec secuirty groups"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "dev-sec"
  }
}
resource "aws_security_group_rule" "ingress-dev" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${Public-ip}"]             # insert your own public-ip here
  security_group_id = aws_security_group.dev-sec.id
}
resource "aws_security_group_rule" "egress-dev" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]                
  security_group_id = aws_security_group.dev-sec.id
}

resource "aws_key_pair" "dev-key" {
  key_name   = "dev-key"
  public_key = file("${Key-Path}")
}

resource "aws_instance" "dev_ec2" {
  instance_type          = "${Instance-type}"
  ami                    = data.aws_ami.myami.id     # you can change the ami type in the datasource.tf file
  key_name               = aws_key_pair.dev-key.id
  vpc_security_group_ids = [aws_security_group.dev-sec.id]
  subnet_id              = aws_subnet.mysubnet.id
  user_data              = file("userdata.tpl")
  tags = {
    name = "dev-ec2"

  }
  provisioner "local-exec" {
  command = templatefile("${var.os-host}-ssh-config.tpl", {       #select either windows or linux as the instance host
    hostname     = self.public_ip,
    user         = "ubuntu",
    IdentityFile = "D:/id_ed25519"
  })
  interpreter = var.os-host == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]



}


}

