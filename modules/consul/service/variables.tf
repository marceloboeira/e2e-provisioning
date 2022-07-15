variable "id" {
  type = string
}

variable "name" {
  type = string
}

variable "node" {
  type = string
}

variable "address" {
  type = string
}

variable "port" {
  type = number
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "meta" {
  type    = map(string)
  default = {}
}
