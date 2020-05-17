provider "linode" { 
}

provider "kubernetes" {
}

provider "helm" {
    kubernetes {
        config_path = "../k8s/.config/kubeconfig.yaml"
    }
}
