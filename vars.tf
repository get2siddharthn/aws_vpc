variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "prv_subnet" {
  description = "private subnets for VPC"
  type        = list(string)
  default     = ["10.0.0.0/26", "10.0.0.64/26", "10.0.0.128/26"]
}

variable "pub_subnet" {
  description = "public subnets for VPC"
  type        = list(string)
  default     = ["10.0.1.0/26", "10.0.1.64/26", "10.0.1.128/26"]
}

variable "azs" {
  description = "Az locations"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "region" {
  default = "ap-south-1"
}