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
    bucket      = var.gcs_bucket
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