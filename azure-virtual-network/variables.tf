variable resource_group_name {}
variable vn_name {}
variable location {}
variable address_space {
  default="10.0.0.0/16"
}
variable subnet_cidr_pub {
  type = "list"
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}
