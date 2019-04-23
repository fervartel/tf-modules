output load_balancer_external_ip {
  description = "The external ip address of the forwarding rule."
  value       = "${google_compute_forwarding_rule.default.ip_address}"
}

output available_zones {
  value = "${data.google_compute_zones.available.names}"
}