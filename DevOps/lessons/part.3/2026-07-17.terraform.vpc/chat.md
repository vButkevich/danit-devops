Today

Maksym Skomorokhov 19:04
1. Как откатить изменения? Предположим что-то пошло не так, сделали ошибку и нужно вернуть назад (особенно если apply
   прошел частично). Только тянуть прошлый файл с кодом до изменений?

2. Если terraform validate проверяет только конфигурацию, но не IAM-права, то как заранее выявить потенциальные
проблемы с разрешениями, которые могут возникнуть во время terraform apply?

3. Насколько оправдано использование нескольких отдельных Terraform-каталогов, каждый со своим state и независимым
запуском? Или в крупных проектах преимущественно используют ТОЛЬКО модули, чтобы сохранять зависимости и
последовательность развёртывания?

4. Было бы классно рассмотреть хотя бы один практический пример использования tf module.
Кинув в чатик ))

denys 19:40
+

Volodymyr Vystavkin 19:40
+

aleksvoronov 19:40
+

Maksym Skomorokhov 19:40
+

Максим 19:40
+

You 19:40
+

Yurii Vilchynskyi 20:07
resource "aws_subnet" "public_a" {
vpc_id = aws_vpc.main.id
cidr_block = var.subnets_cidr.public_a

tags = {
Name = "${local.name_prefix}-public-a"
}
}

Yurii Vilchynskyi 20:12

Yurii Vilchynskyi 20:13
^^^^^^

Volodymyr Vystavkin 20:46
+

Yurii Vilchynskyi 20:57
resource "aws_eip" "lb" {
instance = aws_instance.web.id
domain = "vpc"
}
resource "aws_nat_gateway" "example" {
allocation_id = aws_eip.example.id
subnet_id = aws_subnet.example.id

tags = {
Name = "gw NAT"
}

# To ensure proper ordering, it is recommended to add an explicit dependency
# on the Internet Gateway for the VPC.
depends_on = [aws_internet_gateway.example]
}

denys 21:08
+

Maksym Skomorokhov 21:08
+

denys 21:09
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-main"
  }
}

Yurii Vilchynskyi 21:23
resource "aws_route_table" "public" {
vpc_id = aws_vpc.main.id

route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}

tags = {
Name = "${local.name_prefix}-public-rt"
}
}

resource "aws_route_table" "private" {
vpc_id = aws_vpc.main.id

route {
cidr_block = "0.0.0.0/0"
nat_gateway_id = aws_nat_gateway.main.id # WARNING HERE
}

tags = {
Name = "${local.name_prefix}-private-rt"
}
}
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

denys 21:30
+

Yurii Vilchynskyi 21:33
resource "aws_route_table_association" "public_a" {
subnet_id = aws_subnet.public_a.id
route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
subnet_id = aws_subnet.public_b.id
route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private_a" {
subnet_id = aws_subnet.private_a.id
route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
subnet_id = aws_subnet.private_a.id
route_table_id = aws_route_table.private.id
}

Yurii Vilchynskyi 21:42
data "aws_ami" "ubuntu_26_04" {
most_recent = true

filter {
name = "name"
values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
}

filter {
name = "virtualization-type"
values = ["hvm"]
}

owners = ["099720109477"] # Canonical
}

Maksym Skomorokhov 21:54
І ще мабуть буде треба 

associate_public_ip_address = true

Yurii Vilchynskyi 21:57
resource "aws_security_group" "my_sg" {
name = "tf-sg"
description = "Test"
vpc_id = aws_vpc.main.id

tags = {
Name = "tf-sg"
}
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
security_group_id = aws_security_group.my_sg.id
cidr_ipv4 = "0.0.0.0/0"
from_port = 22
to_port = 22
ip_protocol = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "allow_outbound_all" {
security_group_id = aws_security_group.my_sg.id
cidr_ipv4 = "0.0.0.0/0"
ip_protocol = "-1" # semantically equivalent to all ports
}

Maksym Skomorokhov 21:57
А, ще ключікі ((

Maksym Skomorokhov 22:05
+

Yurii Vilchynskyi 22:06
# Create EC2 in public subnet
# * Create SG that allows SSH from 0.0.0.0/0 and attach it to EC2

resource "aws_instance" "my_ec2" {
ami = data.aws_ami.ubuntu_26_04.id
instance_type = "t3.micro"

key_name = "main-keypait"
subnet_id = aws_subnet.public_b.id
vpc_security_group_ids = [aws_security_group.my_sg.id]

tags = {
Name = "my-ec2"
}
}

output "public_ip" {
value = aws_instance.my_ec2.public_ip
}

resource "aws_security_group" "my_sg" {
name = "tf-sg"
description = "Test"
vpc_id = aws_vpc.main.id

tags = {
Name = "tf-sg"
}
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
security_group_id = aws_security_group.my_sg.id
cidr_ipv4 = "0.0.0.0/0"
from_port = 22
to_port = 22
ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound_all" {
security_group_id = aws_security_group.my_sg.id
cidr_ipv4 = "0.0.0.0/0"
ip_protocol = "-1" # semantically equivalent to all ports
}

Maksym Skomorokhov 22:13
Всім гарного вечора, треба бігти