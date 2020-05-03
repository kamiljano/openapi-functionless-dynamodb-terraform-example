variable "open_api" {
  type = object({
    template_file_path = string
    vars = any
  })
}

variable "application_name" {
  type = string

  description = "The name of your application. All resources will be prefixed with this name"
}

variable "tags" {
  type = any

  default = {}
  description = "Common tags for all created resources"
}