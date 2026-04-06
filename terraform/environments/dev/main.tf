terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

module "namespace" {
  source = "../../modules/namespace"
  name   = "grogu-dev"
  labels = {
    env     = "dev"
    project = "grogu"
  }
}

module "deployment" {
  source    = "../../modules/deployment"
  name      = "deadpool-app"
  namespace = module.namespace.name
  image     = var.image
  replicas  = var.replicas
  environment_vars = {
    DD_SERVICE    = "deadpool-app"
    DD_ENV        = "dev"
    DD_VERSION    = "1.0"
  }
}

module "service" {
  source      = "../../modules/service"
  name        = "deadpool-app"
  namespace   = module.namespace.name
  port        = 8080
  target_port = 8080
}
