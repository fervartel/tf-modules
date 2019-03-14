resource "aws_db_instance" "tf-mysql-instance" {
  identifier                = "tf-rds-instance-${var.rds-env}"
  allocated_storage         = "${var.rds-storage}"
  storage_type              = "${var.rds-storage_type}"
  engine                    = "${var.rds-engine}"
  engine_version            = "${var.rds-engine_version}"
  instance_class            = "${var.rds-instance_class}"
  name                      = "${var.rds-db_name}"
  username                  = "${var.rds-user}"
  password                  = "${var.rds-pass}"
  parameter_group_name      = "${var.rds-param_group_name}"
  db_subnet_group_name      = "${var.rds-db-sn-grp}"
  publicly_accessible       = "${var.rds-pub-access}"
  vpc_security_group_ids    = ["${var.rds-sg}"]
  backup_retention_period   = "${var.rds-bkp_retention}"
  skip_final_snapshot       = "${var.rds-skip_snap}"
}