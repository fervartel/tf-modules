output load_balancer_external_ip {
  description = "The external ip address of the forwarding rule resource"
  value       = "${google_compute_forwarding_rule.main.ip_address}"
}

output available_zones {
  description = "Available zones retrieved by the compute_zones DataSource"
  value = "${data.google_compute_zones.available.names}"
}