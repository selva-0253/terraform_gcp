variable "network" {
  description = "The name of the VPC network"
  type        = string
}

variable "firewall_rules" {
  description = "A map of all firewall rules to create for this VPC"
  type = map(object({
    protocol = string
    ports    = list(string)
    ranges   = list(string)
    tags     = optional(list(string)) # This makes tags optional per rule
  }))
}
variable "firewall_name" {
  description = "The prefix name for the firewall rules"
  type        = string
}
