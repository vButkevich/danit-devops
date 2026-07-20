Today

denys 20:18
+

aleksvoronov 20:18
+

You 20:18
+

Maksym Skomorokhov 20:18
+

Ольга Кирилюк 20:18
+

Volodymyr Vystavkin 20:18
+

Максим 20:18
+_+

Yurii Vilchynskyi 21:16
dev/modules/terraform.tfstate

Maksym Skomorokhov 21:17
Він наче ініціалізується раніше за var

Ольга Кирилюк 21:27
+

Maksym Skomorokhov 21:27
+

denys 21:27
-

Максим 21:27
+

denys 21:45
+

Maksym Skomorokhov 21:45
+

Yurii Vilchynskyi 21:54
output "public_subnets" {
value = [ aws_subnet.public_a.id, aws_subnet.public_b.id ]
}

Yurii Vilchynskyi 22:07
variable "list_of_open_ports" {
default = ["22", "80", "443"]
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
for_each = var.list_of_open_ports

security_group_id = aws_security_group.my_sg.id
cidr_ipv4 = "0.0.0.0/0"
from_port = each.value
to_port = each.value
ip_protocol = "tcp"
}
variable "list_of_open_ports" {
default = ["22", "80", "443"]
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
for_each = toset(var.list_of_open_ports)

security_group_id = aws_security_group.my_sg.id
cidr_ipv4 = "0.0.0.0/0"
from_port = each.value
to_port = each.value
ip_protocol = "tcp"
}