resource "google_compute_network" "vpc" {
  name                    = "${var.name}"
  auto_create_subnetworks = "${var.auto_create_subnetworks}"
}

resource "google_compute_subnetwork" "subnet" {
  # count         = "${length(var.subnet_cidr)}"
  # Evaluates if autocreates subnets flag is TRUE and skips the custom subnets creation
  count         = "${var.auto_create_subnetworks == "True" ? 0 : length(var.subnet_cidr)}"
  name          = "tf-sn-${count.index + 1}"
  ip_cidr_range = "${var.subnet_cidr[count.index]}"
  region        = "${var.subnet_region}"
  network       = "${google_compute_network.vpc.self_link}"
}

resource "google_compute_firewall" "internal" {
  name    = "tf-allow-internal"
  network = "${google_compute_network.vpc.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol  = "tcp"
    ports     = ["0-65535"]
  }

  allow {
    protocol  = "udp"
    ports     = ["0-65535"]
  }

  priority  = 65534
  source_ranges = ["${var.vpc_cidr}"]
}

resource "google_compute_firewall" "icmp" {
  name    = "tf-allow-icmp"
  network = "${google_compute_network.vpc.name}"

  allow {
    protocol = "icmp"
  }

  priority  = 65534
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ssh" {
  name    = "tf-allow-ssh"
  network = "${google_compute_network.vpc.name}"

  allow {
    protocol  = "tcp"
    ports     = ["22"]
  }
  priority  = 65534
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "rdp" {
  name    = "tf--allow-rdp"
  network = "${google_compute_network.vpc.name}"

  allow {
    protocol  = "tcp"
    ports     = ["3389"]
  }

  priority  = 65534
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "http" {
  name    = "tf-allow-http"
  network = "${google_compute_network.vpc.name}"

  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }
  priority  = 1000
  source_ranges = ["0.0.0.0/0"]
}