variable deploy {
  description = "The switch to disable/enable provisioners"
  default     = 1
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "asia-east1"
}

variable zone {
  description = "Zone"
  default     = "asia-east1-b"
}

variable public_key_path {
  description = "Path to the public key for ssh"
}

variable disk_image {
  description = "Diks image"
}

variable ssh_key_for_provisioners {
  description = "SSH private key for provisioners"
}

