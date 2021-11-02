variable "env_type" {
  type = "string"
  default = "dev"
}

variable "aws_region_main" {
  type = "string"
  default = "us-east-1"
}

variable "aws_region_backup" {
  type = "string"
}

variable "common_tags" {
  type = "map"
  default = {
    role = "not-set"
    env =  "not-set"
    app =  "not-set"
  }
}