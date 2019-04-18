# Create a virtual network within the resource group
resource "azurerm_virtual_network" "tf-vn" {
  name                = "${var.vn_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  address_space       = ["${var.address_space}"]
}
# Create as many Public Subnets as especified in the list passed
resource "azurerm_subnet" "tf-sn-pub" {
  count                 = "${length(var.subnet_cidr_pub)}"
  name                  = "tf-sn-pub-${count.index + 1}"
  resource_group_name   = "${var.resource_group_name}"
  virtual_network_name  = "${azurerm_virtual_network.tf-vn.name}"
  address_prefix        = "${var.subnet_cidr_pub[count.index]}"
}