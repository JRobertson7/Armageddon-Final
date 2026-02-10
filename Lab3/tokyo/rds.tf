############################################
# TOKYO MAIN — LAB 3A
# Region: ap-northeast-1
# Role: Application + RDS (PHI authority)
############################################

# --- VPC ---
resource "aws_vpc" "shinjuku_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "shinjuku-vpc" }
}

# --- Subnets ---
resource "aws_subnet" "shinjuku_private" {
  count             = 2
  vpc_id            = aws_vpc.shinjuku_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.shinjuku_vpc.cidr_block, 4, count.index)
  availability_zone = element(["ap-northeast-1a", "ap-northeast-1c"], count.index)

  tags = { Name = "shinjuku-private-${count.index}" }
}

# --- Route Table ---
resource "aws_route_table" "shinjuku_private" {
  vpc_id = aws_vpc.shinjuku_vpc.id
  tags   = { Name = "shinjuku-private-rt" }
}

resource "aws_route_table_association" "shinjuku_private_assoc" {
  count          = length(aws_subnet.shinjuku_private)
  subnet_id      = aws_subnet.shinjuku_private[count.index].id
  route_table_id = aws_route_table.shinjuku_private.id
}

# --- Security Groups ---
resource "aws_security_group" "shinjuku_app_sg" {
  vpc_id = aws_vpc.shinjuku_vpc.id
  name   = "shinjuku-app-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "shinjuku_rds_sg" {
  vpc_id = aws_vpc.shinjuku_vpc.id
  name   = "shinjuku-rds-sg"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.shinjuku_app_sg.id]
  }
}

# --- RDS ---
resource "aws_db_subnet_group" "shinjuku_db_subnets" {
  name       = "shinjuku-db-subnets"
  subnet_ids = aws_subnet.shinjuku_private[*].id
}

resource "aws_db_instance" "shinjuku_rds" {
  identifier             = "shinjuku-medical-db"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "medical"
  username               = "admin"
  password               = "ChangeMe123!"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.shinjuku_rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.shinjuku_db_subnets.name
}