variable "create" {
  description = "Boolean to create resources or not"
  type        = bool
  default     = true
}

########
# Label
########
variable "name" {
  description = "The name for the label"
  type        = string
  default     = "superset"
}

variable "suffix" {
  description = "Suffix to attach to name"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Map of tags"
  type        = map(string)
  default     = {}
}


