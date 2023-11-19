data "aws_caller_identity" "current" {}

locals {
  project_tag = "test"
  project     = "Test"
  env         = "Development"
  region      = "eu-central-1"
  account_id  = data.aws_caller_identity.current.account_id

  # postgres default settings
  db_engine         = "postgres"
  db_engine_version = "15.3"
  db_port           = 5432

  db_name                  = var.db_name
  db_username              = var.db_username
  db_password              = var.db_password
  allowed_ip_addresses     = var.allowed_ip_addresses
  public_ssh_key_file_path = "~/.ssh/serverless-rds.pub"
}

module "network" {
  source = "./modules/network"

  project_tag        = local.project_tag
  project            = local.project
  env                = local.env
  vpc_cidr           = "10.0.0.0/16"
  public_cidrs       = ["10.0.1.0/24"]
  private_cidrs      = ["10.0.2.0/24", "10.0.3.0/24"]
  availability_zones = ["${local.region}a", "${local.region}b"]
}

module "database" {
  source = "./modules/database"

  project_tag         = local.project_tag
  project             = local.project
  env                 = local.env
  vpc_id              = module.network.id
  subnet_group_name   = module.network.private_subnet_group_name
  allocated_storage   = 20
  instance_class      = "db.t3.micro"
  db_engine           = local.db_engine
  db_engine_version   = local.db_engine_version
  db_port             = local.db_port
  db_name             = local.db_name
  db_username         = local.db_username
  db_password         = local.db_password
  skip_final_snapshot = true
}

module "bastion_host" {
  source = "./modules/bastion_host"

  project_tag          = local.project_tag
  project              = local.project
  env                  = local.env
  vpc_id               = module.network.id
  subnet_id            = module.network.public_subnet_ids[0]
  db_security_group_id = module.database.security_group_id
  instance_type        = "t2.micro"
  public_ssh_key       = file(local.public_ssh_key_file_path) # path to public SSH key for bastion host access
  allowed_ip_addresses = local.allowed_ip_addresses
}

module "monitor" {
  source = "./modules/monitor"

  project_tag          = local.project_tag
  project              = local.project
  env                  = local.env
  network_interface_id = module.bastion_host.network_interface_id
  db_port              = local.db_port
}

module "permissions" {
  source = "./modules/permissions"

  project_tag      = local.project_tag
  project          = local.project
  env              = local.env
  region           = local.region
  account_id       = local.account_id
  rds_arn          = module.database.arn
  metric_alarm_arn = module.monitor.rds_metric_alarm_arn
}

module "stop_function" {
  source = "./modules/function"

  project_tag   = local.project_tag
  project       = local.project
  env           = local.env
  region        = local.region
  account_id    = local.account_id
  function_name = "${local.project_tag}-serverless-rds-stop-function"
  ecr_image_tag = "lambda-stop-rds:latest"
  description   = "Function to stop RDS instance"
  role_arn      = module.permissions.stop_role_arn
  env_variables = {
    REGION          = local.region
    RDS_ID          = "${local.project_tag}-serverless-rds"
    METRIC_ALARM_ID = module.monitor.rds_metric_alarm_name
  }
}

module "start_function" {
  source = "./modules/function"

  project_tag   = local.project_tag
  project       = local.project
  env           = local.env
  region        = local.region
  account_id    = local.account_id
  function_name = "${local.project_tag}-serverless-rds-start-function"
  ecr_image_tag = "lambda-start-rds:latest"
  description   = "Function to start RDS instance"
  role_arn      = module.permissions.start_role_arn
  env_variables = {
    REGION = local.region
    RDS_ID = "${local.project_tag}-serverless-rds"
  }
}

module "events" {
  source = "./modules/events"

  project_tag          = local.project_tag
  project              = local.project
  env                  = local.env
  ssh_metric_alarm_arn = module.monitor.ssh_metric_alarm_arn
  start_lambda_arn     = module.start_function.arn
  stop_lambda_arn      = module.stop_function.arn
}
