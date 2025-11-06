variable "secret_path" {
  description = "Path to secrets directory"
  type        = string
}

locals {
  fivetran_api_key    = file("${var.secret_path}/fivetran_api_key.txt")
  fivetran_api_secret = file("${var.secret_path}/fivetran_api_secret.txt")
  tf_svc_acct_key     = file("${var.secret_path}/svc_acct_key.json")
}