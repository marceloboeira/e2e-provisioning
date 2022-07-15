variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "name" {
  type = string
}

variable "engine" {
  type    = string
  default = "redis"
}

variable "port" {
  type    = number
  default = 6379
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "meta" {
  type    = map(string)
  default = {}
}

variable "consul_node" {
  type = string
}
