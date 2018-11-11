variable deploy {
  description = "The switch to enable/disable provisioners"
  default     = 1
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key for ssh"
}

variable name {
  description = "DB name"
}

variable tags {
  description = "DB tags"
  type        = "list"
}

variable ssh_key_for_provisioners {
  description = "Path to ssh private key for provisioners"
}

