############################################
# SAO PAULO MAIN — LAB 3A
# Region: sa-east-1
# Role: Stateless compute only
############################################

# --- VPC ---
resource "aws_vpc" "liberdade_vpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "liberdade-vpc" }
}

# --- Subnets ---
resource "aws_subnet" "liberdade_private" {
  count             = 2
  vpc_id            = aws_vpc.liberdade_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.liberdade_vpc.cidr_block, 4, count.index)
  availability_zone = element(["sa-east-1a", "sa-east-1c"], count.index)

  tags = { Name = "liberdade-private-${count.index}" }
}

# --- Route Table ---
resource "aws_route_table" "liberdade_private" {
  vpc_id = aws_vpc.liberdade_vpc.id
  tags   = { Name = "liberdade-private-rt" }
}

resource "aws_route_table_association" "liberdade_private_assoc" {
  count          = length(aws_subnet.liberdade_private)
  subnet_id      = aws_subnet.liberdade_private[count.index].id
  route_table_id = aws_route_table.liberdade_private.id
}

# --- Security Group ---
resource "aws_security_group" "liberdade_app_sg" {
  vpc_id = aws_vpc.liberdade_vpc.id
  name   = "liberdade-app-sg"

  # App receives traffic from ALB only (simplified here)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Explicit DB egress to Tokyo
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.tokyo.outputs.tokyo_vpc_cidr]
  }
}

# --- EC2 (Stateless App Node) ---
resource "aws_instance" "liberdade_app" {
  ami                         = "ami-0c02fb55956c7d316" # Amazon Linux (example)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.liberdade_private[0].id
  vpc_security_group_ids      = [aws_security_group.liberdade_app_sg.id]
  associate_public_ip_address = false

  tags = { Name = "liberdade-app" }
}
