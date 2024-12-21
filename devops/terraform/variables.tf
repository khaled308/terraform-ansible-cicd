variable "ami" {}
variable "instance_type" {}
variable "vpc_cidr" {}
variable "public_subnets_cidr" {
  type = list(any)
}
variable "public_key" {
  type = string
}

variable "key_name" {
  type = string
}