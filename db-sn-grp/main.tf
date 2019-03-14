resource "aws_db_subnet_group" "tf-db-sn-grp" {
  name          = "tf-db-sn-grp-${var.db-sn-grp_env}"
  description   = "Terraform created - DB Subnet Group for ${var.db-sn-grp_env} environment"
  subnet_ids    = ["${var.db-sn-grp_subnets}"]

  tags = {
    Name = "tf-db-sn-grp-${var.db-sn-grp_env}"
  }
}