module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security_group" {
  source = "./modules/security-group"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
}

module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_group.app_security_group_id
  key_name          = var.key_name
}

module "rds" {
  source = "./modules/rds"

  project_name      = var.project_name
  db_instance_class = var.db_instance_class
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = module.security_group.rds_security_group_id
}
