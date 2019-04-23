variable project {}
variable region {}
variable subnet {}
variable instance_template_type {
  default = "f1-micro"
}
data "google_compute_image" "debian_9" {
    family  = "debian-9"
    project = "debian-cloud"
}
variable min_replicas {
  default = 2
}
variable max_replicas {
  default = 4
}