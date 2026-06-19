resource "google_compute_instance" "my-vm" {
    name = "my-vm"
    machine_type = "e2-micro"
    network_interface {
      network = module.vpc.network_name
      subnetwork = module.vpc.subnets_names[0]
      access_config {
        //ephemeral external ip
      }
    }
    boot_disk {
        auto_delete = true # Automatically deletes disk when VM is destroyed

        initialize_params {
            image = "debian-cloud/debian-12" # Links to the official Debian 12 image
            size  = 50                       # Disk size specified in Gigabytes (GB)
            type  = "pd-balanced"            # Cost-effective performance disk option
        }
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.sanbodx_sa.email
    scopes = ["cloud-platform"]
  }
  allow_stopping_for_update = true 

  
}

resource "google_storage_bucket" "tf-sandbox-bucket" {
  name          = var.tf-bucket
  location      = "US"
  force_destroy = true
  uniform_bucket_level_access = true

}

resource "google_service_account" "sanbodx_sa" {
  account_id   = "sanbodx-sa"
  display_name = "Sanbodx Service Account"
  description  = "Service account for Sanbodx with Compute Engine and BigQuery admin access"
  project      = var.project_id
}

resource "google_project_iam_member" "compute_engine_admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.sanbodx_sa.email}"
}

resource "google_project_iam_member" "bigquery_admin" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.sanbodx_sa.email}"
}


terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0" # Targets major version 6 updates
    }
  }
}

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 18.1"

    project_id   = var.project_id
    network_name = "sandbox-network"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "europe-west9"
        }
    ]

    firewall_rules = [
      {
      name                    = "allow-ssh-from-my-ip"
      description             = "Allow SSH access only from my public IP"
      direction               = "INGRESS"
      priority                = 1000
      ranges                  = ["${var.my_public_ip}"]
      destination_ranges      = []
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      deny       = []
      log_config = null
    },
      {
        name        = "deny-all-egress"
        description = "Deny all other ingress traffic"
        direction   = "EGRESS"
        priority    = 65534
        ranges      = ["${var.ip_all}"]
        allow       = []
        deny = [
          {
            protocol = "all"
            ports    = []
          }
        ]
        log_config = null
      }
    ]

}

provider "google" {
  project = var.project_id
  region  = "europe-west9"
  zone    = "europe-west9-a"
}

