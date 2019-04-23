variable project {}
variable region {}
variable subnet {}
variable instance_template_type {
  default = "f1-micro"
}
variable distribution_policy_zones {
  type = "list"
  default = []
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
# variable zone {
#   default = "us-east1-b"
# }
