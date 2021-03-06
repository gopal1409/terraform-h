# Configure Azure Provider
provider "azurerm" {
  # Version is optional
  # Terraform recommends to pin to a specific version of provider
  #version = "=2.35.0"
  #version = "~>2.35.0"
  #version = "~> 2.37.0"
  features {}
}
resource "azurerm_resource_group" "web_server_rg" {
  name     = var.web_server_rg
  location = var.web_server_location
}
#create a vnet
resource "azurerm_virtual_network" "web_server_vnet" {
  name                = "${var.resource_prefix}-vnet"
  location            = var.web_server_location
  resource_group_name = azurerm_resource_group.web_server_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "web_server_subnet" {
  name                = "${var.resource_prefix}-subnet"
  resource_group_name = azurerm_resource_group.web_server_rg.name
  virtual_network_name = azurerm_virtual_network.web_server_vnet.name 
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "web_server_nic" {
name = "${var.web_server_name}-nic"
location = var.web_server_location
resource_group_name = azurerm_resource_group.web_server_rg.name
 ip_configuration {
   name = "${var.web_server_name}-ip"
   subnet_id = azurerm_subnet.web_server_subnet.id 
   private_ip_address_allocation = "dynamic"
 }
}


