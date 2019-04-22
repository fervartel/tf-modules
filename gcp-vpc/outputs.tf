output "vpc_self_link" {
    value = "${google_compute_network.vpc.self_link}"
}
output "subnets_self_links" {
    value = "${google_compute_subnetwork.subnet.*.self_link}"
}