variable "env" {
  type = string
  description = "env ame value"
}

variable "aws_region" {}

variable "vpc_cidr" {}

variable "subnet_cidr" {}

variable "public_subnet_asign_public_ip" {
    default = true
}