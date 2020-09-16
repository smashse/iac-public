resource "azurerm_public_ip" "template_pip" {
  name                = "template-pip"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.template_rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Template Terraform"
  }
}
