# Networking/variables.tf
variable "vpc_cidr" {
    type = string
}

variable "ipv6_cidr_blocks" {
    type = string
}

variable "public_cidr" {
    type = list
}

variable "private_cidr" {
    type = list
}

variable "public_sn_count" {
    type = number
}

variable "private_sn_count" {
    type = number
}