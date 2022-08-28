
variable "env" {
  description = "Deployment Environment"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
}

variable "pub_subnet" {
  type        = list(string)
  description = "CIDR block for Public Subnet"
}

variable "prv_subnet" {
  type        = list(string)
  description = "CIDR block for Private Subnet"
}

variable "azs" {
  type        = list(string)
  description = "AZ in which all the resources will be deployed"
}

variable "region" {
  default = "ap-south-1"
}