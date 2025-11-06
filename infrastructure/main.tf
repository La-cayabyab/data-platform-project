terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.7.0"
    }

    fivetran = {
      source  = "fivetran/fivetran"
      version = ">= 1.0.0"
    }

  }
}

provider "google" {
  credentials = local.tf_svc_acct_key
  project     = "dataplatform-lab-internal-v1"
  region      = "us-east4"
}

provider "fivetran" {
  api_key    = local.fivetran_api_key
  api_secret = local.fivetran_api_secret
}

# MODULES

module "gcp" {
  source = "./modules/gcp"
  providers = {
    google = google
  }
}

module "fivetran" {
  source     = "./modules/fivetran"
  gcs_bucket = module.gcp.gcs_bucket
  providers = {
    fivetran = fivetran
  }
}


output "fivetran_service_account_key" {
  value     = module.gcp.fivetran_service_account_key
  sensitive = true
}