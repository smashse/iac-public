resource "azurerm_network_interface" "template_ni" {
  name                = "template-ni"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.template_rg.name

  ip_configuration {
    name                          = "template_ipc"
    subnet_id                     = azurerm_subnet.template_sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.template_pip.id
  }

  tags = {
    environment = "Template Terraform"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.template_ni.id
  network_security_group_id = azurerm_network_security_group.template_nsg.id
}
