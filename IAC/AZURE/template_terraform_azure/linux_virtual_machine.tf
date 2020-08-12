resource "tls_private_key" "template_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "tls_private_key" { value = "tls_private_key.template_ssh.private_key_pem" }

resource "azurerm_linux_virtual_machine" "template_instance" {
  name                  = "template-instance"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.template_rg.name
  network_interface_ids = [azurerm_network_interface.template_ni.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "template-instance-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "template-instance"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.template_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.template_sa.primary_blob_endpoint
  }

  tags = {
    environment = "Template Terraform"
  }
}
