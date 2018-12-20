data "aws_availability_zones" "zones" {}

resource "aws_db_instance" "prod"
{
  identifier = "${var.PROJECT_NAME}-prod-rds"
  #final_snapshot_identifier = "${var.PROJECT_NAME}-prod-rds-final-snapshot"
  allocated_storage = "${var.RDS_ALLOCATED_STORAGE}"
  storage_type = "gp2"
  engine = "${var.RDS_ENGINE}"
  engine_version = "${var.ENGINE_VERSION}"
  instance_class = "${var.DB_INSTANCE_CLASS}"
  backup_retention_period = "${var.BACKUP_RETENTION_PERIOD}"
  publicly_accessible = "${var.PUBLICLY_ACCESSIBLE}"
  username = "${var.RDS_USERNAME}"
  password = "${var.RDS_PASSWORD}"
  vpc_security_group_ids = ["${aws_security_group.rds-prod.id}"]
  db_subnet_group_name = "${aws_db_subnet_group.rds_subnet_group.name}"

  multi_az = "true"
  skip_final_snapshot = "true"

  depends_on = ["aws_vpc.main"]
}


resource "aws_db_subnet_group" "rds_subnet_group" {

    name          = "${var.PROJECT_NAME}_mysql_db_subnet_group"
    description   = "Allowed subnets for MySQL DB cluster instances"
    subnet_ids    = [
      "${aws_subnet.private_subnet_1.id}",
      "${aws_subnet.public_subnet_1.id}",
    ]

    tags {
        Name         = "${var.PROJECT_NAME}-rds-Subnet-Group"
    }
 depends_on = ["aws_subnet.public_subnet_1", "aws_subnet.private_subnet_1"]
}



resource "aws_vpc" "main" {
  cidr_block = "${var.VPC_CIDR_BLOCK}"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags = {
    Name = "${var.PROJECT_NAME}-rds-vpc"
  }
  depends_on = ["aws_vpc.main"]
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.VPC_PUBLIC_SUBNET1_CIDR_BLOCK}"
  availability_zone = "${data.aws_availability_zones.zones.names[0]}"
  map_public_ip_on_launch = "true"
  tags {
    Name = "${var.PROJECT_NAME}-rds-public-subnet-1"
  }
  depends_on = ["aws_vpc.main"]
}


resource "aws_subnet" "private_subnet_1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.VPC_PRIVATE_SUBNET1_CIDR_BLOCK}"
  availability_zone = "${data.aws_availability_zones.zones.names[1]}"
  map_public_ip_on_launch = "true"
  tags {
    Name = "${var.PROJECT_NAME}-rds-priavet-subnet-1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.PROJECT_NAME}-rds-internet-gateway"
  }
}


resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${var.PROJECT_NAME}-rds-public-route-table"
  }
}

output "rds_prod_endpoint"
{
  value = "${aws_db_instance.prod.endpoint}"
}
