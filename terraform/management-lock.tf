#
# Azure Locks
#
# Create Azure custom role to allow Azure lock creation
# Policy scope can be Subscription, Resource Group or Storage Account
# Policy permissions:
# - Microsoft.Authorization/locks/read
# - Microsoft.Authorization/locks/write
# - Microsoft.Authorization/locks/delete

resource "azurerm_management_lock" "main" {
  name       = "CanNotDelete"
  scope      = azurerm_storage_account.main.id
  lock_level = "CanNotDelete"
  notes      = "Locked to prevent accidental deletion"
}
