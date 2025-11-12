# ----------- SERVICE ACCOUNTS & ROLES -----------

locals {
  service_accounts = {
    "composer-tf-service-account" = {
      display_name = "Composer Terraform Service Account"
      description  = "Service account for Cloud Composer environment"
    }
    "bqowner" = {
      display_name = "BigQuery Owner Service Account"
      description  = "Service account for BigQuery ownership"
    }
    "dbt-service-account" = {
      display_name = "dbt Service Account"
      description  = "Service account for dbt"
    }
    "fivetran-service-account" = {
      display_name = "Fivetran Service Account"
      description  = "Service account for Fivetran"
    }
    "kestra-service-account" = {
      display_name = "Kestra Service Account"
      description  = "Service account for Kestra"
    }
  }
  role_assignments = {
    "roles/bigquery.user" = [
      google_service_account.service_accounts["dbt-service-account"].email,
      google_service_account.service_accounts["fivetran-service-account"].email,
      google_service_account.service_accounts["kestra-service-account"].email
    ]
    "roles/bigquery.dataEditor" = [
      google_service_account.service_accounts["dbt-service-account"].email,
      google_service_account.service_accounts["kestra-service-account"].email
    ]
    "roles/bigquery.dataViewer" = [
      google_service_account.service_accounts["dbt-service-account"].email
    ]
    "roles/bigquery.admin" = [
    ]
    "roles/storage.objectViewer" = [
      "g-ensign-indispensably@fivetran-production.iam.gserviceaccount.com",
      google_service_account.service_accounts["kestra-service-account"].email
    ]
    "roles/composer.worker" = [
      google_service_account.service_accounts["composer-tf-service-account"].email
    ]
    "roles/storage.admin" = [
      google_service_account.service_accounts["composer-tf-service-account"].email,
      google_service_account.service_accounts["fivetran-service-account"].email,
      google_service_account.service_accounts["kestra-service-account"].email
    ]
    "roles/storage.objectCreator" = [
      google_service_account.service_accounts["kestra-service-account"].email
    ]
  }

  # Flatten to create individual assignments
  flattened_assignments = flatten([
    for role, users in local.role_assignments : [
      for user in users : {
        role = role
        user = user
      }
    ]
  ])
}

resource "google_service_account" "service_accounts" {
  for_each = local.service_accounts

  account_id   = each.key
  display_name = each.value.display_name
  description  = each.value.description
  project      = "dataplatform-lab-internal-v1"
}

resource "google_project_iam_member" "role_assignments" {
  for_each = { for idx, assignment in local.flattened_assignments : "${assignment.role}-${assignment.user}" => assignment }

  project = "dataplatform-lab-internal-v1"
  role    = each.value.role
  member  = "serviceAccount:${each.value.user}"
}

# this is a Fivetran provisioned service account that HAS to be used for connection config
resource "google_storage_bucket_iam_member" "fivetran_gcs_access" {
  bucket = google_storage_bucket.test_gcp_bucket[0].name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:g-ensign-indispensably@fivetran-production.iam.gserviceaccount.com"
}

resource "google_service_account_key" "fivetran_key" {
  service_account_id = google_service_account.service_accounts["fivetran-service-account"].name
}

# ----------- APPS/STORAGE RESOURCES -----------

resource "google_storage_bucket" "test_gcp_bucket" {
  count         = 1
  name          = "dataplatform-lab-internal-v1-test-gcp-bucket"
  location      = "US"
  force_destroy = true
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_composer_environment" "cloud_composer_test_env" {
  count  = 0
  name   = "dataplatform-lab-internal-v1-example-composer-env"
  region = "us-east4"
}

resource "google_bigquery_dataset" "sample_internal_db" {
  dataset_id    = "sample_internal_db"
  friendly_name = "Sample Internal DB"
  description   = "This is a test description"
  location      = "US"

  labels = {
    env = "default"
  }

  access {
    role          = "roles/bigquery.dataOwner"
    user_by_email = google_service_account.service_accounts["bqowner"].email
  }

  access {
    role          = "roles/bigquery.dataEditor"
    user_by_email = google_service_account.service_accounts["dbt-service-account"].email
  }


  access {
    role   = "READER"
    domain = "hashicorp.com"
  }
}