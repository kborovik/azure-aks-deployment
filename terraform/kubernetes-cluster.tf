#
# Azure Kubernetes Services (AKS).
#

resource "azurerm_kubernetes_cluster" "main" {
  kubernetes_version      = var.kubernetes_version
  name                    = local.long_name
  resource_group_name     = azurerm_resource_group.main.name
  location                = var.location
  node_resource_group     = "${local.long_name}-node-pool"
  dns_prefix              = local.long_name
  private_cluster_enabled = false # Kubernetes API exposed only to the internal network
  sku_tier                = "Free"

  network_profile {
    # network_policy    = "calico"        # options: calico or azure
    network_plugin    = "kubenet"      # options: kubenet or azure
    load_balancer_sku = "Basic"        # options: Standard or Basic
    outbound_type     = "loadBalancer" # types: loadBalancer or userDefinedRouting
  }

  default_node_pool {
    name                  = "nodepool1"
    vm_size               = var.vm_size
    os_disk_size_gb       = 32
    node_count            = 1
    enable_auto_scaling   = false
    enable_node_public_ip = false
    type                  = "VirtualMachineScaleSets"
    tags                  = local.tags
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }

  tags = local.tags
}

# To grant AKS cluster ability to update resources (DNS records) in 'aks-shared' resource group,
# create a custom role in 'aks-shared' resource group and assign the following permissions to SPN:
# - Microsoft.Authorization/roleAssignments (read,write,delete)
resource "azurerm_role_assignment" "shared" {
  scope                = azurerm_resource_group.shared.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

output "aks_name" {
  description = "AKS Name"
  value       = azurerm_kubernetes_cluster.main.name
}
