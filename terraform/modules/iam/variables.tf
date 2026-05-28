variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "policy_document" {
  type = string
}