# Providers 
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.5.0"
    }
    http = {
      source = "hashicorp/http"
      version = "2.1.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider "kubernetes" {
  config_context = var.config_context
  config_path    = var.config_path
}

# Local Data
locals {
}

data "http" "argocd-template" {
  url = var.argocd_url
}


resource "kubernetes_namespace" "argocd" {
  metadata {
    annotations = {
      label = "argocd"
    }
    name = "argocd"
  }
}

resource "local_file" "argocd-template-create" {
  content = data.http.argocd-template.body
  filename = "argocd-template.yaml"
}

resource "null_resource" "apply-argocd-template" {
  depends_on = [
    kubernetes_namespace.argocd,
    local_file.argocd-template-create
  ]
  provisioner "local-exec" {
    command = "kubectl apply -f argocd-template.yaml -n argocd"
  }
}

resource "null_resource" "pause" {
  depends_on = [
    kubernetes_namespace.argocd
  ]
  provisioner "local-exec" {
    command = "sleep 5"
  } 
  
}

resource "null_resource" "print-default-password" {
  depends_on = [
    kubernetes_namespace.argocd,
    local_file.argocd-template-create,
    null_resource.apply-argocd-template,
    null_resource.pause
  ]
  provisioner "local-exec" {
    when = create
    command = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
  }
}

