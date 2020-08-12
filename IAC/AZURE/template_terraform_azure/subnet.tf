resource "azurerm_subnet" "template_sn" {
  name                 = "template-sn"
  resource_group_name  = azurerm_resource_group.template_rg.name
  virtual_network_name = azurerm_virtual_network.template_vn.name
  address_prefixes     = ["10.0.2.0/24"]
}
