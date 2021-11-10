# Providers 
terraform {
  required_providers {
    kind = {
      source = "kyma-incubator/kind"
      version = "0.0.9"
    }
  }
}



# Local Data
locals {
}

# Kind Init
resource "kind_cluster" "kind-base" {
  name = "base"
  wait_for_ready = true
  kind_config  {
     kind = "Cluster"
     api_version = "kind.x-k8s.io/v1alpha4"
     networking {
        disable_default_cni = var.disable_cni
        pod_subnet = "192.168.0.0/16"
     }
     node {
        role = "control-plane"
        image = "kindest/node:${var.k8s_version}"
        kubeadm_config_patches = [
        <<-INTF
kind: InitConfiguration
nodeRegistration:
  kubeletExtraArgs:
    node-labels: "ingress-ready=true"
        INTF
        ]
       extra_port_mappings {
         container_port = var.container_port_http
         host_port = var.host_port_http
       }
       extra_port_mappings {
         container_port = var.container_port_https
         host_port = var.host_port_https
       }

     }
     node{
        role = "worker"
        image = "kindest/node:${var.k8s_version}"
        kubeadm_config_patches = [
        <<-INTF
kind: JoinConfiguration
nodeRegistration:
    kubeletExtraArgs:
        node-labels: "deployment.group=${var.deployment_group_label}"
        INTF
        ]        
     }
  }
}
