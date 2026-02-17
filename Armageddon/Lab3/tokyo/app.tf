# Tokyo Application Servers
# Hosts the application instances in Tokyo region

resource "aws_instance" "tokyo_app" {
  count           = 2
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.shinjuku_private[count.index].id
  security_groups = [aws_security_group.shinjuku_app_sg.id]

  tags = {
    Name = "tokyo-app-${count.index + 1}"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
