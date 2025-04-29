environment                = "prod"
instance_type             = "t3.small"
instance_count            = 2
root_volume_size          = 50
enable_deletion_protection = true
create_https_listener     = true
certificate_arn           = "arn:aws:acm:region:account:certificate/certificate-id"
allowed_cidr_blocks       = ["10.0.0.0/8"]
