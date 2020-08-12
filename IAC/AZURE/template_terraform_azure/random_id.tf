resource "random_id" "template_rid" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.template_rg.name
  }

  byte_length = 8
}
