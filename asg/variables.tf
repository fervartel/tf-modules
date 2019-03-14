data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20180912"] # Free Tier
  }

  owners = ["099720109477"] # Canonical
}
variable "ssh_key" {
  default = "fvarela-aws"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "security_groups" {
  type = "list"
  default = []
}
variable "subnets" {
  type = "list"
  default = []
}
variable "asg_lb_target_group" {
  type = "list"
  default = []
}