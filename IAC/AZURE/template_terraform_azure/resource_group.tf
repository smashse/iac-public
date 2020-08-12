resource "azurerm_resource_group" "template_rg" {
  name     = "template-rg"
  location = "eastus"

  tags = {
    environment = "Template Terraform"
  }
}
