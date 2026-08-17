module "gke" {
  source                  = "git::git::https://github.com/health-100/h100-gke-terraform-modules//modules/private-service-connect-securehub?ref=main"
  project_id              = "my-gcp-team"
  cluster_name            = "abhishek"
  region                  = "us-west3"
  env-type                = "nonprod"
  description             = "creating new psc cluster with cloudbuild"
  network_project_id      = "host"
  network                 = "network"
  subnetwork              = "subnet"

  cluster_resource_labels = {
    "costcenter" : "123"
    "owner" : "platform"
    "lineofbusiness" : "h100-digital"
  }

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n2d-standard-8"
      min_count          = 1
      max_count          = 20
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
      enable_secure_boot = true
    }
    # _extra_node_pools
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  node_pools_labels = {
    all = {
    }
    # _extra_node_pool_labels
  }

  node_pools_metadata = {
    all = {
      serial-port-logging-enable = false
    }
  }

  node_pools_tags = {
    all = []
    # _custom_tags
  }

  node_pools_taints = {
    all = []
    # _extra_node_pool_taints
  }
}

# Istio internal IP address: 10.10.10.10
# Istio internal proxy IP address for external LB: 10.10.10.10

terraform {
  required_version = ">= 1.0.8"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "<= 6.42.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "<= 6.42.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
