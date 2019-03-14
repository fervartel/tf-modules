variable "vpc_env" {
  default = ""
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "vpc_tenancy" {
  default = "default"
}
variable "subnet_cidr_pub" {
  type = "list"
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}
variable "subnet_cidr_pri" {
  type = "list"
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}
data "aws_availability_zones" "azs" {}