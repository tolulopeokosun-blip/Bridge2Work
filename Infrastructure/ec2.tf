resource "aws_instance" "web_a" {
  ami                    = "ami-08c40ec9ead489470" 
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "${var.project_name}-web-a"
  }
}

resource "aws_instance" "web_b" {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_b.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "${var.project_name}-web-b"
  }
}
