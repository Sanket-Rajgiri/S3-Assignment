variable "regions" {
  type = map(any)
}
variable "product" {
  default = "phoenix"
}
variable "environment" {
  type = any
}
