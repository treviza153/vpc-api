variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "access_token_validity_hours" {
  description = "Validity of the Access token in hours (1–24)"
  type        = number
  default     = 1
}

variable "id_token_validity_hours" {
  description = "Validity of the ID token in hours (1–24)"
  type        = number
  default     = 1
}

variable "refresh_token_validity_days" {
  description = "Validity of the Refresh token in days (1–3650)"
  type        = number
  default     = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}
