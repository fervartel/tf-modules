# Custom Security group - MySQL
resource "aws_security_group" "tf-sg-mysql" {
  name        = "tf-sg-mysql"
  description = "Terraform created - Allow MySQL inbound traffic"
  vpc_id      = "${var.sg_vpc_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-sg-mysql"
  }
}