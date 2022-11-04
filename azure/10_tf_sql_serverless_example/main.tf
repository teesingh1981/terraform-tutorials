provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
    location = var.location
    name     = var.rg_name
}

resource "azurerm_sql_server" "sqlserver" {
    name                        = var.sqlserver_name
    resource_group_name         = azurerm_resource_group.rg.name
    location                    = var.location
    version                     = "12.0"

    administrator_login         = var.admin
    administrator_login_password = var.admin_password
}

resource "azurerm_mssql_database" "serverless_db" {
    name                        = "serverles-db"
    server_id                   = azurerm_sql_server.sqlserver.id
    collation                   = "SQL_Latin1_General_CP1_CI_AS"

    auto_pause_delay_in_minutes = 60
    max_size_gb                 = 32
    min_capacity                = 0.5
    read_replica_count          = 0
    read_scale                  = false
    sku_name                    = "GP_S_Gen5_1"
    zone_redundant              = false

    threat_detection_policy {
        disabled_alerts      = []
        email_account_admins = "Disabled"
        email_addresses      = []
        retention_days       = 0
        state                = "Disabled"
        use_server_default   = "Disabled"
    }
}
