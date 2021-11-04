
variable "config_path"{
    default = "~/.kube/config"
    type = string
}
variable "config_context"{
    default = "kind-base"
    type = string
}

variable "argocd_url"{
    default = "https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
    type = string
}

