## used in combination of an CNI module
variable "disable_cni" {
    default = false
    type = bool
}

variable "deployment_group_label" {
    default = "worker"
    type = string
}
