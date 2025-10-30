variable "svc-acct-auth-key" {
  description = "auth key"
  default     = "/Users/la.cayabyab/Downloads/dataplatform-lab-internal-v1-tf-service-account.json"
}

variable "fivetran_api_key" {
  description = "Fivetran API key for provisioning instance via Terraform"
  default     = ""
}

variable "fivetran_api_secret" {
  description = "Fivetran API secret for provisioning instance via Terraform"
  default     = ""
}