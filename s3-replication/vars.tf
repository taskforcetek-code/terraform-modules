variable "env_type" {
  type = string
  default = "dev"
}

variable "aws_region_main" {
  type = string
  default = "us-east-1"
}

variable "aws_region_backup" {
  type = string
  default = "us-east-2"
}

variable "bucket_name" {
  type = string
  default = "state"
}

variable "common_tags" {
  type = map
  default = {
    role = "not-set"
    env =  "not-set"
    app =  "not-set"
  }
}
