# Create EC2 in public subnet
# * Create SG that allows SSH from 0.0.0.0/0 and attach it to EC2

resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.ubuntu_26_04.id
  instance_type = "t3.micro"

  key_name               = "main-keypait"
  subnet_id              = aws_subnet.public_b.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "my-ec2"
  }
}

output "public_ip" {
  value = aws_instance.my_ec2.public_ip
}

resource "aws_security_group" "my_sg" {
  name        = "tf-sg"
  description = "Test"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "tf-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_all" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_security_group" "my_private" {
  name        = "private-sg"
  description = "Test"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "tf-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id            = aws_security_group.my_private.id
  referenced_security_group_id = aws_security_group.my_sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_all" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
