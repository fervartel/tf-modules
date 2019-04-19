# Create a virtual network within the resource group specified in the variable <<resource_group_name>>
resource "azurerm_virtual_network" "tf-vn" {
  name                = "${var.vn_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  address_space       = ["${var.address_space}"]
}
# Create as many subnets as specified in the <<subnet_cidr>> variable list
resource "azurerm_subnet" "tf-sn" {
  count                 = "${length(var.subnet_cidr)}"
  name                  = "tf-sn-${count.index + 1}"
  resource_group_name   = "${var.resource_group_name}"
  virtual_network_name  = "${azurerm_virtual_network.tf-vn.name}"
  address_prefix        = "${var.subnet_cidr[count.index]}"
}