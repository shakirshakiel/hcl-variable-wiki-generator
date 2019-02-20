variable "enable" {
    description = "Enable / Disable the resources in the module"
    default     = 1
}

variable "network_connections" { 
    description = "List of network connections"
    default = []
}
