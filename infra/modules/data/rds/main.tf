resource "aws_security_group" "rds" {
  name        = "employee-rds"
  description = "Allow inbound traffic from ECS security group and My IP"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL connection from instances belonging to the ECS cluster"
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = [var.ecs_sg_id]
  }

  egress {
    description = "Allow all outbound traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "rds_sub_one" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-2b"
}

resource "aws_subnet" "rds_sub_two" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-2c"
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.rds_sub_one.id
  route_table_id = var.pub_rt_id
}

resource "aws_route_table_association" "rta_sub_two" {
  subnet_id      = aws_subnet.rds_sub_two.id
  route_table_id = var.pub_rt_id
}


# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html#USER_VPC.Subnets
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "mysql_sub_group" {
  name       = "main"
  subnet_ids = [aws_subnet.rds_sub_one.id, aws_subnet.rds_sub_two.id]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#argument-reference
resource "aws_db_instance" "default" {
  #Minimum
  allocated_storage = 200
  identifier        = "dev"
  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t3.micro"
  username          = "admin"
  password          = "testpassword"

  network_type           = "IPV4"
  db_subnet_group_name   = aws_db_subnet_group.mysql_sub_group.name
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot = true
}