resource "azurerm_resource_group" "template_rg" {
  name     = "template-rg"
  location = var.azure_location

  tags = {
    environment = "Template Terraform"
  }
}
