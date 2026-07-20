module "network" {
  source = "../../_modules/network"

env         = var.env
aws_region  = var.aws_region
vpc_cidr    = var.vpc_cidr
subnet_cidr = var.subnet_cidr
}
