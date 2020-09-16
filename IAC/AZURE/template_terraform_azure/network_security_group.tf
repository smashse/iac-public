resource "azurerm_network_security_group" "template_nsg" {
  name                = "template-nsg"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.template_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Template Terraform"
  }
}
