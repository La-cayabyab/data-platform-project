output "gcs_bucket" {
  value       = google_storage_bucket.test_gcp_bucket[0].name
  description = "The name of the GCS bucket created for Fivetran to load data into BigQuery."

}

output "service_accounts" {
  value       = google_service_account.service_accounts
  description = "The service accounts created in this module."
}

output "fivetran_service_account_key" {
  value     = google_service_account_key.fivetran_key.private_key
  sensitive = true
}