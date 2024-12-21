provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "khaled308-terraform-state"
    key    = "cicd1/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source              = "./modules/VPC"
  vpc_cidr            = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
  availability_zones  = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "public_instance_sg" {
  source  = "./modules/SG"
  vpc_id  = module.vpc.vpc_id
  sg_name = "public-instance-sg"
  ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "ec2" {
  source              = "./modules/EC2"
  ami                 = var.ami
  instance_type       = var.instance_type
  key_name            = var.key_name
  public_key = var.public_key
  subnet_id           = module.vpc.public_subnet_ids[0]
  security_group_id   = module.public_instance_sg.sg_id
  associate_public_ip_address = true
  tags = {
    Name: "public-instance"
  }
}

resource "null_resource" "generate_hosts_file" {
  triggers = {
    instance_ip = module.ec2.ec2_public_ip
  }

  provisioner "local-exec" {
    command = "echo '${self.triggers.instance_ip} ansible_ssh_user=ec2-user' > ../ansible/hosts"
  }
}
