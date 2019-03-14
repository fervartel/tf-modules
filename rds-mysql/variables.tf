variable "rds-env" {
  default = ""
}
variable "rds-storage" {
  default = "20"
}
variable "rds-storage_type" {
  default = "gp2"
}
variable "rds-engine" {
  default = "mysql"
}
variable "rds-engine_version" {
  default = "5.7"
}
variable "rds-instance_class" {
  default = "db.t2.micro"
}
variable "rds-db_name" {
  default = "tfMySQLDB"
}
variable "rds-user" {
  default = "admin"
}
variable "rds-pass" {
  default = "Passw0rd"
}
variable "rds-param_group_name" {
  default = "default.mysql5.7"
}
variable "rds-db-sn-grp" {
  default = ""
}
variable "rds-pub-access" {
  default = "true"
}
variable "rds-sg" {
  type="list"
  default = []
}
variable "rds-bkp_retention" {
  default = "0"
}
variable "rds-skip_snap" {
  default = "true"
}