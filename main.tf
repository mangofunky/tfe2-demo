#Deploy Networking Resources

module "networking" {
  source   = "./networking"
  vpc_cidr = "10.123.0.0/16"
  #ipv6_cidr_block = "::/0"
  public_sn_count = 3
  private_sn_count = 4
  public_cidr = [for i in range(2,255,2) : cidrsubnet("10.123.0.0/16", 8 , i)]
  private_cidr = [for i in range(1,255,2) : cidrsubnet("10.123.0.0/16", 8 , i)]
}
