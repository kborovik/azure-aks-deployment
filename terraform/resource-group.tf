resource "azurerm_resource_group" "main" {
  name     = local.long_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "shared" {
  name     = "${var.project}-shared"
  location = var.location
  tags = {
    "managed_by" = "https://github.com/kborovik/azure-aks-deployment"
  }

  lifecycle {
    prevent_destroy = true
  }
}

