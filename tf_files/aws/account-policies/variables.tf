variable "region" {
  default = "us-east-2"
}

variable "roles" {
  description = "Create these IAM roles"
  type        = list(string)
  default     = ["devopsdirector", "bsdisocyber", "projectmanagerplanx", "devopsplanx", "devplanx"]
}

