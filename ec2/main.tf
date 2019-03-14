# Generic EC2 instance
resource "aws_instance" "tf-instance" {
  count           = "${var.instance_count}"
  #ami            = "${var.ami}"
  ami             = "${data.aws_ami.ubuntu.id}" # Region agnostic
  instance_type   = "${var.instance_type}"
  subnet_id       = "${var.ec2_subnet}"
  security_groups = ["${var.ec2_sg}"]
  key_name 	      = "${var.ssh_key}"

  tags = {
    Name = "tf-instance-${count.index + 1}-${var.ec2_env}"
  }
}