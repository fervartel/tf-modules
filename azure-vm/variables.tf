variable "prefix" {
  default = "tf-vm"
}
variable resource_group_name {}
variable location {}
variable subnet {}
variable computername {
  default = "hostname"
}
variable adminuser {
  default = "testuser"
}
variable adminpass {
  default = "Password-123!"
}