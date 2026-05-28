variable "hosted_zone_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "api_id" {
  type = string
}

variable "stage_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
