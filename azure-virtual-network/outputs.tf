output "subnets" {
    value = "${azurerm_subnet.tf-sn.*.id}"
}