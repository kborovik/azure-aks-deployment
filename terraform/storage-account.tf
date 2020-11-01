resource "azurerm_storage_account" "main" {
  name                      = local.short_name
  resource_group_name       = azurerm_resource_group.shared.name
  location                  = var.location
  account_kind              = "StorageV2"
  account_tier              = "Standard" # options: Standard, Premium
  account_replication_type  = "LRS"      # options: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS
  access_tier               = "Hot"      # options: Hot, Cold
  enable_https_traffic_only = true
  tags                      = local.tags

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "kubernetes_storage" {
  name                  = "kubernetes-storage"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}
