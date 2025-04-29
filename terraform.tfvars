aws_region           = "us-east-1"
project_name         = "my-project"
environment          = "dev"
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]
instance_type        = "t3.micro"
instance_count       = 2
root_volume_size     = 20
allowed_cidr_blocks  = ["0.0.0.0/0"]

additional_tags = {
  Owner       = "DevOps"
  CostCenter  = "12345"
}
