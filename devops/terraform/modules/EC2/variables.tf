variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}


variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "associate_public_ip_address" {
  type = bool
}

variable "tags" {
  type = map(string)
}

variable "public_key" {
    type = string
}
