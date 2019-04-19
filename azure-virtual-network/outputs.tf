output "subnets_pub" {
    value = "${azurerm_subnet.tf-sn-pub.*.id}"
}