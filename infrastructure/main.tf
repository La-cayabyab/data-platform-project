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
}

# module "fivetran" {
#   source = "./modules/fivetran"
# }

resource "fivetran_destination" "bigquery_destination" {
  group_id         = "ensign_indispensably"
  service          = "big_query"
  region           = "GCP_US_EAST4"
  time_zone_offset = "-5"
  run_setup_tests  = true

  config {
    project_id        = "dataplatform-lab-internal-v1"
    data_set_location = "US"
  }
}

resource "fivetran_connector" "google_cloud_storage" {
  group_id = fivetran_destination.bigquery_destination.group_id
  service  = "gcs"

  destination_schema {
    name  = "raw_gcs"
    table = "posts"
  }

  config {
    bucket      = module.gcp.gcs_bucket
    folder_path = "/"
    file_type   = "json"
  }

  lifecycle {
    ignore_changes = [
      config.files,
      config.folder_path
    ]
  }

}

output "fivetran_service_account_key" {
  value     = module.gcp.fivetran_service_account_key
  sensitive = true
}