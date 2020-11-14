resource "azurerm_linux_virtual_machine" "github-runner" {
  name                            = "github-runner"
  resource_group_name             = azurerm_resource_group.shared.name
  location                        = var.location
  size                            = "Standard_B2s"
  admin_username                  = "github"
  disable_password_authentication = true
  provision_vm_agent              = true
  custom_data                     = base64encode(file("cloud-init.sh"))

  network_interface_ids = [
    azurerm_network_interface.github-runner.id
  ]

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = "github"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDG6xu0DGHlc3JBmsgZmwIkbO9C2GDNGDDSLfOTbyt+uYPP9sgYn78DLsWxoIr9ASYuH/XlsOfV9/+uSn/Mu/723EuLIoPq6+woxPCjLdtx/n9JtSg74VtuvQm28aocOcIePkF3upxvHSNkNmOiatW3o2OC5S3C6hQHaJtwrif27Yb2ABNx68wCohXypyKriM3RN7W1LQ8HUXTxWWBpqtmyoqxnOZS5vcjC4La6p+HoxmT1Zjk5yyqvV3LWowHmSHSBcHxptYo2Oa252gStw8Al3nMdIotUhi+Ni/vyUzVSXKjUIqe9D4A5OPJiUUfhIqMevmtS+hRKlHKUB9SXH022f4ePvwcTMKI6RCqIVIN9SUIM6hHNCH8PGb47TKVKJRbUHJy93rELPpE1keDQS/2JwMhl6Jb5SFrkCvSF7ZUzim4DOFBJU7o6PedVHfZs+SyDBfE3wMZGJYdltEA2unfFzLzpS31zbK5VYDxQ9rDssNwZ8HTgqZmuARtTjG1WhIc="
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    "managed_by" = "https://github.com/kborovik/azure-aks-deployment"
  }
}

resource "azurerm_network_interface" "github-runner" {
  name                = "github-runner"
  resource_group_name = azurerm_resource_group.shared.name
  location            = var.location

  ip_configuration {
    name                          = "github-runner"
    subnet_id                     = azurerm_subnet.subnet-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.github-runner.id
  }

  tags = {
    "managed_by" = "https://github.com/kborovik/azure-aks-deployment"
  }
}

resource "azurerm_network_security_group" "github-runner" {
  name                = "github-runner"
  resource_group_name = azurerm_resource_group.shared.name
  location            = var.location

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    "managed_by" = "https://github.com/kborovik/azure-aks-deployment"
  }
}

resource "azurerm_network_interface_security_group_association" "github-runner" {
  network_interface_id      = azurerm_network_interface.github-runner.id
  network_security_group_id = azurerm_network_security_group.github-runner.id
}

resource "azurerm_public_ip" "github-runner" {
  name                = "github-runner"
  resource_group_name = azurerm_resource_group.shared.name
  location            = var.location
  allocation_method   = "Dynamic"
  domain_name_label   = "lab5-github-runner-01"
  ip_version          = "IPv4"

  tags = {
    "managed_by" = "https://github.com/kborovik/azure-aks-deployment"
  }
}
