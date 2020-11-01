resource "azurerm_dns_zone" "main" {
  name                = "${var.environment}.${var.dns_root_zone}"
  resource_group_name = azurerm_resource_group.shared.name
  tags                = local.tags

  lifecycle {
    prevent_destroy = true
  }
}
