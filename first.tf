# provider "aws" {
#     region = "us-east-1"
#     profile = "default"
# }
  
# resource "aws_instance'" "ec2" {
#     ami = "ami-0c2b8ca1dad447f8a"
#     instance_type = "t2.micro"
#     tags = {
#         Name = "ec2"
#     }
  
# }

terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "XXXXXXXXXXXXXXXXXXXXXXXXX"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = var.project_name
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  project_name          = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  additional_tags      = var.additional_tags
}

module "security" {
  source = "./modules/security"

  project_name        = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  allowed_cidr_blocks = var.allowed_cidr_blocks
  additional_tags    = var.additional_tags
}

module "alb" {
  source = "./modules/alb"

  project_name               = var.project_name
  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  public_subnet_ids         = module.vpc.public_subnet_ids
  security_group_id         = module.security.alb_security_group_id
  health_check_path         = var.health_check_path
  enable_deletion_protection = var.enable_deletion_protection
  create_https_listener     = var.create_https_listener
  certificate_arn           = var.certificate_arn
  additional_tags           = var.additional_tags
}

module "ec2" {
  source = "./modules/ec2"

  project_name          = var.project_name
  environment          = var.environment
  instance_type        = var.instance_type
  instance_count       = var.instance_count
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  security_group_id    = module.security.ec2_security_group_id
  root_volume_size     = var.root_volume_size
  target_group_arn     = module.alb.target_group_arn
  additional_tags      = var.additional_tags
}
