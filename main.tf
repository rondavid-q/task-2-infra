# main.tf

provider "aws" {
  region = "ap-south-1" 

module "vpc" {
  source = "./modules/vpc"
}

module "subnet" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id
}

module "internet_gateway" {
  source = "./modules/internet_gateway"
  vpc_id = module.vpc.vpc_id
}

module "security_group" {
  source = "./modules/security_group"
}

module "route_table" {
  source = "./modules/route_table"
  vpc_id = module.vpc.vpc_id
  igw_id = module.internet_gateway.igw_id
}

module "nat_gateway" {
  source   = "./modules/nat_gateway"
  subnet_id = module.subnet.private_subnet_id
  igw_id    = module.internet_gateway.igw_id
  ec2_instance_allocation_id = module.ec2_instance.allocation_id
}

module "ec2_instance" {
  source          = "./modules/ec2_instance"
  subnet_id       = module.subnet.private_subnet_id
  vpc_security_group_ids = [module.security_group.sg_id]
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  key_pair_name   = var.key_pair_name
}
