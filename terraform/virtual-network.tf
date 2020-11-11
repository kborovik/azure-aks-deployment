resource "azurerm_virtual_network" "shared" {
  name                = "${var.project}-shared"
  address_space       = ["172.16.0.0/16"]
  resource_group_name = azurerm_resource_group.shared.name
  location            = var.location

  tags = {
    "managed_by" = "https://github.com/kborovik/azure-aks-deployment"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_subnet" "subnet-1" {
  name                 = "subnet-1"
  resource_group_name  = azurerm_resource_group.shared.name
  virtual_network_name = azurerm_virtual_network.shared.name
  address_prefixes     = ["172.16.0.0/24"]
}
