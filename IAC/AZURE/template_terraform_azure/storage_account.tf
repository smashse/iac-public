resource "azurerm_storage_account" "template_sa" {
  name                     = "diag${random_id.template_rid.hex}"
  resource_group_name      = azurerm_resource_group.template_rg.name
  location                 = var.azure_location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = "Template Terraform"
  }
}
