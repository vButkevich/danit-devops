locals {
  name_prefix = "tf"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "${local.name_prefix}-main"
  }
}

# Public subnets
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnets_cidr.public_a
  availability_zone = "${var.aws_region}a" # "eu-central-1a"

  tags = {
    Name = "${local.name_prefix}-public-a"
  }
}


resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnets_cidr.public_b
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${local.name_prefix}-public-b"
  }
}

### Дописати 2 приватні
