/*
resource "random_id" "random_id_prefix" {
  byte_length = 2
}
*/

module "aws_vpc" {
  source     = "./modules/aws_vpc"
  region     = var.region
  env        = var.env
  vpc_cidr   = var.vpc_cidr
  pub_subnet = var.pub_subnet
  prv_subnet = var.prv_subnet
  azs        = var.azs
}