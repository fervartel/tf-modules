resource "google_compute_instance" "vm" {
  name         = "${var.name}"
  machine_type = "${var.machine_type}"

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    # # A default network is created for all GCP projects
    # network       = "default"
    network = "${var.vpc}"
    access_config = {
    }
  }
}