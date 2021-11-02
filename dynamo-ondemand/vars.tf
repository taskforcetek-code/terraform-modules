variable env_type {
  type = string
  default = "dev"
}

variable "table_name" {
  type = string
  default = "table-name"
}

variable hash_key {
  type = string
  default = "LockID"
}

variable table_attributes {
  type        = list(map(string))
  default     = [{
      name = "LockID"
      type = "S"
    }]
}

variable "common_tags" {
  type = map
  default = {
    role = "not-set"
    env =  "not-set"
    app =  "not-set"
  }
}
