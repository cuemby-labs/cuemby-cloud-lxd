
variable "instance_name" {
  description = "LXD instance name"
  type        = string
}

variable "instance_image" {
  description = "LXD instance image"
  type        = string
  default     = "almalinux/8/cloud"
}

variable "instance_target" {
  description = "LXD instance target"
  type        = string
}

variable "cpu_limits" {
  description = "LXD instance cpu limits"
  type        = string
  default     = "4"
}

variable "memory_limits" {
  description = "LXD instance memory limits"
  type        = string
  default     = "16GiB"
}

#
# Contextual Fields
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}
