variable "prefix" {
  description = "Prefix to construct Azure globally unique names (part of naming convention)"
  type        = string
  default     = "lab5"
}

variable "project" {
  description = "Project Name (part of naming convention)"
  type        = string
  default     = "aks"
}

variable "environment" {
  description = "Deployment environment (dev|stg|prd) to construct resource names (part of naming convention)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Microsoft Azure regions"
  type        = string
  default     = "eastus2"
}

variable "tenant_id" {
  description = "Azure Active Directory Tenants ID"
  type        = string
  default     = ""
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = ""
}

variable "client_id" {
  description = "Azure Active Directory Service Principal Name"
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "Azure Active Directory Service Principal Name password"
  type        = string
  default     = ""
}

variable "kubernetes_version" {
  description = "Kubernetes version to deploy"
  type        = string
  default     = "1.19.0"
}

variable "vm_size" {
  description = "Azure AKS pool VM SKU size"
  type        = string
  default     = "Standard_E2_v3" # alternatives: Standard_B2ms (8G_RAM), Standard_E2_v3 (16G_RAM, C$117/M)
}

variable "vm_min_count" {
  description = "Azure AKS pool VM min count"
  type        = number
  default     = "1"
}

variable "vm_max_count" {
  description = "Azure AKS pool VM max count"
  type        = number
  default     = "4"
}

variable "dns_root_zone" {
  type        = string
  description = "FQDN for root DNS zone"
  default     = "lab5.ca"
}
