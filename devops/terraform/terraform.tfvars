ami           = "ami-0453ec754f44f9a4a"
instance_type = "t2.micro"
vpc_cidr      = "172.16.0.0/16"
public_subnets_cidr = [
  "172.16.0.0/20"
]

key_name = "cicd_key"