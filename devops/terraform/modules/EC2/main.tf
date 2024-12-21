resource "aws_instance" "ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  security_groups             = [var.security_group_id]
  associate_public_ip_address = var.associate_public_ip_address
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = var.public_key
}