resource "azurerm_virtual_network" "template_vn" {
  name                = "template-vn"
  address_space       = ["10.0.0.0/16"]
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.template_rg.name

  tags = {
    environment = "Template Terraform"
  }
}
