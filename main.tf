locals {
  project                 = "Test"
  env                     = "Development"
  region                  = "eu-central-1"
  rds_instance_identifier = "${lower(local.project)}-serverless-rds"
  db_port                 = 5432
}

module "network" {
  source = "./modules/network"

  project              = local.project
  env                  = local.env
  vpc_cidr_block       = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24", "10.0.3.0/24"] # must be two subnets in order for the RDS Instance to work
  availability_zones   = ["eu-central-1a", "eu-central-1b"]
}

module "database" {
  source = "./modules/database"

  identifier           = local.rds_instance_identifier
  project              = local.project
  env                  = local.env
  vpc_id               = module.network.id
  db_subnet_group_name = module.network.private_subnet_group_name
  allocated_storage    = 20
  instance_class       = "db.t3.micro"
  db_engine            = "postgres"
  db_engine_version    = "15.3"
  db_port              = local.db_port
  db_name              = var.db_name
  db_username          = "postgres"
  db_password          = var.db_password
  skip_final_snapshot  = true
}

module "bastion_host" {
  source = "./modules/bastion_host"

  project              = local.project
  env                  = local.env
  vpc_id               = module.network.id
  subnet_id            = module.network.public_subnet_ids[0]
  db_security_group_id = module.database.db_security_group_id
  instance_type        = "t2.micro"
  public_key           = file("~/.ssh/ec2-instance.pub") # path to public SSH key for Bastion Host access
  allowed_ip_addresses = ["0.0.0.0/0"]
}

module "stop_rds_function" {
  source = "./modules/function"

  function_name  = "stop-rds-function"
  stop           = true
  project        = local.project
  env            = local.env
  region         = local.region
  rds_identifier = local.rds_instance_identifier
  db_arn         = module.database.arn
  ecr_image_tag  = "lambda-stop-rds:latest"
}

module "start_rds_function" {
  source = "./modules/function"

  function_name  = "start-rds-function"
  stop           = false
  project        = local.project
  env            = local.env
  region         = local.region
  rds_identifier = local.rds_instance_identifier
  db_arn         = module.database.arn
  ecr_image_tag  = "lambda-start-rds:latest"
}

module "monitor" {
  source = "./modules/monitor"

  project                           = local.project
  env                               = local.env
  bastion_host_network_interface_id = module.bastion_host.network_interface_id
  port                              = local.db_port
  trigger_period                    = 20 # in minutes
  lambda_arn                        = module.stop_rds_function.arn
}
