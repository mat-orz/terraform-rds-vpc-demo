# Project wide variable
PROJECT_NAME                          = "demo"

# Varibles for the Providers
AWS_ACCESS_KEY                        = ""
AWS_SECRET_KEY                        = ""
AWS_REGION                            = "eu-west-2"

# RDS variable
RDS_CIDR                              = "0.0.0.0/0"
DB_INSTANCE_CLASS                     = "db.t2.micro"
RDS_ENGINE                            = "mysql"
ENGINE_VERSION                        = "5.6.41"
BACKUP_RETENTION_PERIOD               = "7"
PUBLICLY_ACCESSIBLE                   = "true"
RDS_USERNAME                          = "administrator"
RDS_PASSWORD                          = "test123$#"
RDS_ALLOCATED_STORAGE                 = "10"


# VPC Variables
VPC_CIDR_BLOCK                        = "10.0.0.0/16"
VPC_PUBLIC_SUBNET1_CIDR_BLOCK         = "10.0.1.0/24"
VPC_PRIVATE_SUBNET1_CIDR_BLOCK        = "10.0.3.0/24"

