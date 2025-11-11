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

# Connector for posts data
resource "fivetran_connector" "google_cloud_storage_posts" {
  group_id = fivetran_destination.bigquery_destination.group_id
  service  = "gcs"

  destination_schema {
    name  = "raw_gcs"
    table = "posts"
  }

  config {
    bucket      = var.gcs_bucket
    folder_path = "/raw_data/posts"
    file_type   = "json"
  }

  lifecycle {
    ignore_changes = [
      config
    ]
  }
}

# Connector for comments data
resource "fivetran_connector" "google_cloud_storage_comments" {
  group_id = fivetran_destination.bigquery_destination.group_id
  service  = "gcs"

  destination_schema {
    name  = "raw_gcs"
    table = "comments"
  }

  config {
    bucket      = var.gcs_bucket
    folder_path = "/raw_data/comments" # Specify comments directory
    file_type   = "json"
  }

  lifecycle {
    ignore_changes = [
      config
    ]
  }
}

# Connector for users data
resource "fivetran_connector" "google_cloud_storage_users" {
  group_id = fivetran_destination.bigquery_destination.group_id
  service  = "gcs"

  destination_schema {
    name  = "raw_gcs"
    table = "users"
  }

  config {
    bucket      = var.gcs_bucket
    folder_path = "/raw_data/users"
    file_type   = "json"
  }

  lifecycle {
    ignore_changes = [
      config
    ]
  }
}