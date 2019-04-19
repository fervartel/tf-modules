resource "azurerm_network_security_group" "tf-sg-ssh" {
  name                = "tf-sg-ssh"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}
resource "azurerm_network_security_rule" "tf-sg-rule-ssh" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.tf-sg-ssh.name}"
}
resource "azurerm_public_ip" "tf-pub-ip" {
  name                = "tf-pub-ip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "Dev"
  }
}
resource "azurerm_network_interface" "tf-nic" {
  name                = "${var.prefix}-nic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  network_security_group_id = "${azurerm_network_security_group.tf-sg-ssh.id}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${var.subnet}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.tf-pub-ip.id}"
  }
}
resource "azurerm_virtual_machine" "tf-vm" {
  name                  = "${var.prefix}-instance"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.tf-nic.id}"]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "tf-os-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.computername}"
    admin_username = "${var.adminuser}"
    admin_password = "${var.adminpass}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "Dev"
  }
}