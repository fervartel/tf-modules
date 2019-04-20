output "vmss_fqdn" {
  value = "${azurerm_public_ip.vmss.fqdn}"
}

output "jumpbox_fqdn" {
  value = "${azurerm_public_ip.jumpbox.fqdn}"
}