resource "azurerm_public_ip" "vmss" {
  name                         = "tf-vmss-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  allocation_method            = "Static"
  domain_name_label            = "${var.resource_group_name}"
  tags                         = "${var.tags}"
}

resource "azurerm_lb" "vmss" {
  name                = "tf-vmss-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.vmss.id}"
  }

  tags = "${var.tags}"
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.vmss.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "vmss" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.vmss.id}"
  name                = "ssh-running-probe"
  port                = "${var.application_port}"
}

resource "azurerm_lb_rule" "lbnatrule" {
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.vmss.id}"
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = "${var.application_port}"
  backend_port                   = "${var.application_port}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.bpepool.id}"
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = "${azurerm_lb_probe.vmss.id}"
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "tf-vmscaleset"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_B1s"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "tf-vm-"
    admin_username       = "${var.adminuser}"
    admin_password       = "${var.adminpass}"
    custom_data          = "${file("web.conf")}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      primary                                = true
      subnet_id                              = "${var.subnet}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.bpepool.id}"]
    }
  }

  tags = "${var.tags}"
}

resource "azurerm_monitor_autoscale_setting" "vmss" {
  name                = "tf-autoscaling-settings"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  target_resource_id  = "${azurerm_virtual_machine_scale_set.vmss.id}"

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 4
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = "${azurerm_virtual_machine_scale_set.vmss.id}"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = "${azurerm_virtual_machine_scale_set.vmss.id}"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  # notification {
  #   email {
  #     send_to_subscription_administrator    = true
  #     send_to_subscription_co_administrator = true
  #     custom_emails                         = ["admin@contoso.com"]
  #   }
  # }
}

resource "azurerm_public_ip" "jumpbox" {
  name                         = "tf-jumpbox-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  allocation_method            = "Static"
  domain_name_label            = "${var.resource_group_name}-ssh"
  tags                         = "${var.tags}"
}

resource "azurerm_network_interface" "jumpbox" {
  name                = "tf-jumpbox-nic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = "${var.subnet}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.jumpbox.id}"
  }

  tags = "${var.tags}"
}

resource "azurerm_virtual_machine" "jumpbox" {
  name                  = "tf-jumpbox"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.jumpbox.id}"]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "tf-jumpbox-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "tf-jumpbox"
    admin_username = "${var.adminuser}"
    admin_password = "${var.adminpass}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = "${var.tags}"
}