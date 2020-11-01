terraform {
  backend "azurerm" {
    snapshot = true
  }
  required_version = ">=0.13"
}
