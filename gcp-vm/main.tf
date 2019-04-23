resource "google_compute_instance" "vm" {
  name         = "${var.name}"
  machine_type = "${var.machine_type}"

  tags = ["http-server"]
  
  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
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