terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.23.0"
    }
  }
}
provider "azurerm" {
  features {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

 
# grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "gr-sisinfo-entel-ci"
  location = "Central US"
}
 
resource "azurerm_storage_account" "sa" {
  name                     = "saucbenteldelta01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}
 
resource "azurerm_storage_container" "raw-entel" {
  name                  = "raw-entel"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "llamaditascsv" {
  name = "llamaditas.csv"
  storage_account_name = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.raw-entel.name 
  type = "Block"
  source = "dataset/llamaditas-entel.csv"
}

resource "azurerm_storage_blob" "llamadasxls" {
  name = "llamadas.xlsx"
  storage_account_name = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.raw-entel.name 
  type = "Block"
  source = "dataset/llamadas-entel.xlsx"
}

resource "azurerm_storage_blob" "llamadas" {
  name                   = "llamadas"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.raw-entel.name
  type                   = "Block"
  source                 = "Dataset/llamadas.csv"
}

resource "azurerm_storage_blob" "datos" {
  name                   = "dato01"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.raw-entel.name
  type                   = "Block"
  source                 = "Dataset/dato02"
}

resource "azurerm_storage_blob" "csv_06" {
  name                   = "06.csv"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.raw-entel.name
  type                   = "Block"
  source                 = "Dataset/06.csv"
}


# base de datos sql
 
resource "azurerm_mssql_server" "db" {
  name                         = "sql-ucb-sisinfo-entel-delta"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "franklin"
  administrator_login_password = "" 
}

resource "azurerm_mssql_firewall_rule" "rulefirewall" {
  name             = "FirewallRule1"
  server_id        = azurerm_mssql_server.db.id 
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

resource "azurerm_mssql_database" "dw-entel" {
  name         = "dw_entel_delta"
  server_id    = azurerm_mssql_server.db.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"
 
  tags = {
    foo = "bar"
  }
 
  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}

# agregar  data factory

resource "azurerm_data_factory" "df" {
  name                = "adf-ucb-dw-entel-8055452-8848488"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}