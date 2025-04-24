provider "azurerm" {
  features {}
  subscription_id = "d06b631a-2df9-4819-889a-501e8204ee16"
}

resource "azurerm_resource_group" "gaia_rg" {
  name     = "resource-group-gaia"
  location = "France Central"
}

resource "azurerm_virtual_network" "gaia_vnet" {
  name                = "gaia-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.gaia_rg.location
  resource_group_name = azurerm_resource_group.gaia_rg.name
}

resource "azurerm_subnet" "gaia_subnet" {
  name                 = "gaia-subnet"
  resource_group_name  = azurerm_resource_group.gaia_rg.name
  virtual_network_name = azurerm_virtual_network.gaia_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_mssql_server" "gaia_sql_server" {
  name                         = "gaia-sql-server"
  resource_group_name          = azurerm_resource_group.gaia_rg.name
  location                     = azurerm_resource_group.gaia_rg.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssw0rd1234!"
}

resource "azurerm_mssql_database" "gaia_sql_db" {
  name           = "gaia-db"
  server_id      = azurerm_mssql_server.gaia_sql_server.id
  sku_name       = "S0"
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  zone_redundant = false
} 

