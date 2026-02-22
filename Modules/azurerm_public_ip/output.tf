output "pip_address" {
    value = {for k,v in azurerm_public_ip.pips: k=> v.ip_address}
}