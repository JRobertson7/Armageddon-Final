resource "aws_security_group" "obsidian_rds_sg" {
  name        = "obsidian.rds-sg"
  description = "RDS access from EC2"
  vpc_id      = "vpc-xxxxxxxxxxxxc90c017"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.obsidian_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "obsidian_ec2_sg" {
  name        = "obsidian.ec2-sg"
  description = "sg for ec2"
  vpc_id      = "vpc-xxxxxxxxxxc90c017"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["73.191.193.93/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "mysql" {
  identifier        = "Obsidian_rds01"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = "labdb"

  username = "admin"
  password = "REDACTED"

  vpc_security_group_ids = [aws_security_group.sg_rds_lab.id]
  publicly_accessible    = false
  skip_final_snapshot    = true

   tags = {
    Name = "jr-lab-mysql"
  }
}

resource "aws_instance" "app" {
  ami                    = "ami-0532be01f26a3de55"  # Amazon Linux 2023 (us-east-1)
  instance_type          = "t3.micro"
  subnet_id              = "subnet-00ce0af067aefd418"
  vpc_security_group_ids = [aws_security_group.obsidian_ec2_sg
.id]

  tags = {
    Name = "obsidian-app"
  }
}
