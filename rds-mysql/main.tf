resource "aws_db_instance" "tf-mysql-instance" {
  identifier                = "tf-mysql-instance-${var.rds-mysql_env}"
  allocated_storage         = 20
  storage_type              = "gp2"
  engine                    = "mysql"
  engine_version            = "5.7"
  instance_class            = "db.t2.micro"
  #name                     = "tfMySQLDB${var.rds-mysql_env}"
  name                      = "tfmysqldb"
  username                  = "admin"
  password                  = "Passw0rd"
  parameter_group_name      = "default.mysql5.7"
  db_subnet_group_name      = "${var.rds-mysql_db-sn-grp}"
  publicly_accessible       = true
  vpc_security_group_ids    = ["${var.rds-mysql_sg}"]
  backup_retention_period   = 0
  skip_final_snapshot       = true
}