# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------

variable project {
  type        = string
  description = "The id of the google project where the CDN will be created"
}

variable dns_name {
  type        = string
  description = "The dns name to create which point to the CDN"
  default     = "devops-technical.lab.innovorder.io"
}

variable google_dns_managed_zone_name {
  type        = string
  description = "The name of the Google DNS Managed Zone where the DNS will be created"
  default     = "lab-innovorder-io"
}
