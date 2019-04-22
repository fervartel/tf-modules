resource "google_compute_instance" "vm" {
  name         = "${var.name}"
  machine_type = "${var.machine_type}"

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    # network     = "${var.vpc}" # To use only if creating a VM using a vpc with 'auto_create_subnetworks = True'
    subnetwork    = "${var.subnet}"
    access_config = {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<SCRIPT
    sudo apt-get -y update
    sudo apt-get -y dist-upgrade
    sudo apt-get -y install nginx
    SCRIPT

  metadata {
    sshKeys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
  }
}