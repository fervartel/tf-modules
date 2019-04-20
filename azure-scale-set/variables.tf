variable resource_group_name {}
variable location {}
variable subnet {}
variable "application_port" {
  description = "The port that you want to expose to the external load balancer"
  default     = 80
}
variable adminuser {
  default = "testuser"
}
variable adminpass {
  default = "Password-123!"
}
variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = "map"

  default = {
    environment = "Dev"
  }
}