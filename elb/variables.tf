variable "elb_vpc_id" {
  default = ""
}
variable "elb_target_type" {
  default = "instance"
}
variable "elb_protocol" {
  default = "HTTP"
}
variable "elb_port" {
  default = "80"
}
variable "elb_scheme_internal" {
  default = "false"
}
variable "elb_type" {
  default = "application"
}
variable "elb_sg" {
  type = "list"
}
variable "elb_sn" {
  type = "list"
}