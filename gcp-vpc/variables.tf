variable name {
  default = "tf-vpc"
}
variable auto_create_subnetworks {
  default = "false"
}
variable vpc_cidr {
  default = "10.0.0.0/16"
}
variable subnet_cidr {
  type = "list"
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}
variable subnet_region {
  default = "us-east1"
}