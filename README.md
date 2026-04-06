Grogu

Infrastructure as Code using Terraform to provision Kubernetes resources with a fully automated CI/CD pipeline via GitHub Actions.

Overview

This project demonstrates a modular Terraform workflow for managing Kubernetes infrastructure. Reusable modules handle namespace creation, application deployment, and service exposure. A GitHub Actions pipeline spins up an ephemeral kind cluster, runs `terraform plan` on pull requests for review, and runs `terraform apply` on merge to `main`. No external cluster or stored credentials required.

Stack

Layer	-  Technology
Infrastructure	-  Terraform
Orchestration -	Kubernetes (kind)
CI/CD  -	GitHub Actions
Cluster Provisioning -	helm/kind-action
Provider - 	hashicorp/kubernetes

Pipeline

Every push to `main` triggers the full pipeline. Pull requests run through plan only.

1. Checkout code
2. Setup Terraform
3. Create ephemeral kind cluster inside the runner
4. Verify cluster access via kubectl
5. Terraform init
6. Terraform validate
7. Terraform plan (saved to file)
8. Terraform apply (merge to main only)

The plan is saved with `-out=tfplan` so the apply step executes the exact reviewed plan. The apply step is gated with a conditional that checks for `refs/heads/main` and `event_name == 'push'`.

Getting started

git clone git@github.com:GHFury/Grogu.git
cd Grogu

# Create a local kind cluster
kind create cluster --name grogu

# Apply the dev environment
cd terraform/environments/dev
terraform init
terraform plan
terraform apply

Terraform modules

Namespace
Creates a Kubernetes namespace with configurable labels.

module "namespace" {
  source = "../../modules/namespace"
  name   = "grogu-dev"
  labels = { env = "dev", project = "grogu" }
}

Deployment

Creates a Kubernetes deployment with configurable image, replicas, ports, environment variables, and liveness/readiness probes.

module "deployment" {
  source         = "../../modules/deployment"
  name           = "deadpool-app"
  namespace      = module.namespace.name
  image          = var.image
  replicas       = var.replicas
  container_port = 80
  environment_vars = {
    DD_SERVICE = "deadpool-app"
    DD_ENV     = "dev"
    DD_VERSION = "1.0"
  }
}

Service
Exposes the deployment internally via ClusterIP.

module "service" {
  source      = "../../modules/service"
  name        = "deadpool-app"
  namespace   = module.namespace.name
  port        = 80
  target_port = 80
}

Project structure

.github/workflows/        CI/CD pipeline
terraform/environments/   Environment-specific configs (dev)
terraform/modules/        Reusable Terraform modules
  namespace/              Kubernetes namespace
  deployment/             Kubernetes deployment with probes
  service/                Kubernetes service (ClusterIP)

Lessons learned

Building this pipeline surfaced several real-world issues worth documenting.
Local kind clusters run at localhost and cannot be reached from GitHub Actions runners. The fix is to create an ephemeral kind cluster directly inside the runner using `helm/kind-action`.

Setting `image_pull_policy` to `Never` works locally where images are pre-loaded with `kind load`, but breaks in CI where the image must be pulled from a registry. Changed to `IfNotPresent`.

Swapping the application image for `nginx:latest` without updating ports and probe paths caused the deployment to hang indefinitely. The probes were hitting `/health` on port 8080 while nginx serves on port 80 with no `/health` endpoint. Pods restart-looped until the probes and ports were corrected.

GitHub Actions masks any log output that matches a stored secret value. This obscured the real Terraform error until the unused secret was deleted.

Hardcoding `config_context` in the Terraform provider ties you to a specific cluster name. Removing it lets Terraform use whatever cluster is currently active, which works both locally and in CI without modification.

Development notes

The dev environment currently uses `nginx:latest` as a placeholder image. To deploy the actual application image, push it to a container registry and update `var.image` in the dev environment config.
To add a new environment, copy `terraform/environments/dev` to a new directory and adjust the variable values. The modules are reusable across environments without modification.
