locals {
  server_name         = "server-${random_string.random_id.result}"
  resource_group_name = "rg-${random_string.random_id.result}"

}

resource "random_string" "random_id" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = "North Europe"
}

resource "azurerm_mssql_server" "sql_server" {
  name                = local.server_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  version             = "12.0"
  minimum_tls_version = "1.2"

  azuread_administrator {
    login_username              = var.admin_username
    object_id                   = var.admin_object_id
    azuread_authentication_only = true
  }
}

resource "azurerm_mssql_database" "sql_database" {
  name         = "example-db"
  server_id    = azurerm_mssql_server.sql_server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 1
  sku_name     = "Basic"
}