variable "ec2_env" {
  default = ""
}
variable "instance_count" {
  default = "1"
}
# Enable this variable to pass the AMI ID as an argument
/* variable "ami" {
  default = "ami-0ac019f4fcb7cb7e6"
} */
# This Data Source enables us to get the AMI list of a particular distro
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20180912"] # Free Tier
  }

  owners = ["099720109477"] # Canonical
}
variable "instance_type" {
  default = "t2.micro"
}
variable "ec2_subnet" {
  default = ""
}
variable "ec2_sg" {
  default = ""
}
variable "ssh_key" {
  default = "fvarela-aws"
}