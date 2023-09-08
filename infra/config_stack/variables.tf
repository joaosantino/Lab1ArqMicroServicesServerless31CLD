variable "my_tags" {
  type = map(string)
  default = {
    StackName = "LAB01-31CLD"
  }
}

variable "bucket_name" {
  type    = string
  default = "lab01"
}

variable "unique_id" {
  type    = string
  default = ""
}
