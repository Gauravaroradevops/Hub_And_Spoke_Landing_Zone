output "rg_id" {
    value = {for k, v in azurerm_resource_group.rgs: k=> v.id}  
}
output "rg_name" {
    value = {for k, v in azurerm_resource_group.rgs: k=> v.name}  
}