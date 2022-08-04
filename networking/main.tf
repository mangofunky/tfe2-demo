data "aws_availability_zones" "available" {}

# ---- networking/main.tf -----
resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "tfe_vpc" {
  cidr_block           = var.vpc_cidr
  ipv6_cidr_block      = var.ipv6_cidr_blocks
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tfe_vpc-${random_integer.random.id}"
  }
}

resource "aws_subnet" "tfe_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.tfe_vpc.id
  cidr_block              = var.public_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "tfe_public_${count.index + 1}"
  }
}

resource "aws_subnet" "tfe_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.tfe_vpc.id
  cidr_block              = var.private_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "tfe_private_${count.index + 1}"
  }
}


resource "aws_security_group" "deny-access-ssh" {
  name        = "deny-ssh-access"
  description = "Deny access on port 22 from 0.0.0.0/0"
  vpc_id      = aws_vpc.tfe_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    #cidr_blocks      = ["0.0.0.0/0"]
    cidr_blocks      = [aws_vpc.tfe_vpc.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.tfe_vpc.ipv6_cidr_block]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    #cidr_blocks      = ["0.0.0.0/0"]
    cidr_blocks      = [aws_vpc.tfe_vpc.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.tfe_vpc.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
