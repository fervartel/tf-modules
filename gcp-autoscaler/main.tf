resource "google_compute_instance_template" "main" {
  name           = "tf-vm-template"
  machine_type   = "${var.instance_template_type}"
  can_ip_forward = false

  tags = ["http-server"]

  disk {
    source_image = "${data.google_compute_image.debian_9.self_link}"
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
  
  lifecycle {
    create_before_destroy = true
  }

  # service_account {
  #   scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  # }
}

resource "google_compute_forwarding_rule" "default" {
  project               = "${var.project}"
  name                  = "tf-forwarding-rule"
  target                = "${google_compute_target_pool.main.self_link}"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
}

resource "google_compute_http_health_check" "default" {
  project      = "${var.project}"
  name         = "tf-healthcheck"
  request_path = "/"
  port         = "80"
}

resource "google_compute_target_pool" "main" {
  name = "tf-target-pool"
  
  session_affinity = "NONE"

  health_checks = [
  "${google_compute_http_health_check.default.name}",
  ]
}

resource "google_compute_region_instance_group_manager" "main" {
  name = "tf-igm"
  region = "${var.region}"
  distribution_policy_zones = ["${data.google_compute_zones.available.names}"]
  instance_template  = "${google_compute_instance_template.main.self_link}"

  target_pools       = ["${google_compute_target_pool.main.self_link}"]
  base_instance_name = "tf-vm"
}

data "google_compute_zones" "available" {
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_region_autoscaler" "main" {
  name   = "tf-autoscaler"
  target = "${google_compute_region_instance_group_manager.main.self_link}"

  autoscaling_policy {
    min_replicas    = "${var.min_replicas}"
    max_replicas    = "${var.max_replicas}"
    cooldown_period = 120

    cpu_utilization {
      target = 0.5
    }
  }
}