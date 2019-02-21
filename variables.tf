variable "required_string" {
    description = "Required string"
}

variable "default_string" {
    description = "Default string"
    default     = "1"
}

variable "empty_list" { 
    description = "Empty List"
    type = "list"
    default = []
}

variable "non_empty_list" { 
    description = "Non empty List"
    default = ["a", "b"]
}

variable "required_list" { 
    description = "Required List"
    type = "list"
}

variable "empty_map" { 
    description = "Empty map"
    type = "map"
    default = {}
}

variable "non_empty_map" { 
    description = "Non empty Map"
    default = {
        "a" = "b"
        "c" = "d"
    }
}

variable "required_map" { 
    description = "Required Map"
    type = "map"
}
