variable deploy {
  description = "The switch to enable/disable provisioners"
  default     = 1
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key for ssh"
}

variable name {
  description = "App name"
}

variable db_internal_ip {
  description = "DB instance IP"
}

variable tags {
  description = "App tags"
  type        = "list"
}

variable app_ip_name {
  description = "App ip resource name"
}

variable ssh_key_for_provisioners {
  description = "Path to ssh private key for provisioners"
}

