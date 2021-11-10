## used in combination of an CNI module
variable "disable_cni" {
    default = false
    type = bool
}

variable "deployment_group_label" {
    default = "worker"
    type = string
}

variable "container_port_http" {
    default = 80
    type = number
}

variable "host_port_http" {
    default = 80
    type = number
}

variable "container_port_https" {
    default = 443
    type = number
}

variable "host_port_https" {
    default = 443
    type = number
}

variable "k8s_version" {
    default = "v1.21.1"
    type = string
}