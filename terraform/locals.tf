locals {
  long_name  = "${var.project}-${var.environment}"
  short_name = "${var.prefix}${var.project}${var.environment}" # should be used for globally unique objects, storage accounts, traffic manager, etc
  tags = {
    env        = var.environment
    service    = var.project
    managed_by = "https://github.com/kborovik/azure-aks-deployment"
  }
}
