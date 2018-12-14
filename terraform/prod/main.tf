provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

terraform {
  backend "gcs" {
    bucket = "tf-back-prod"
    prefix = "terraform/state"
  }
}

module "db" {
  deploy                   = "${var.deploy}"
  source                   = "../modules/db"
  public_key_path          = "${var.public_key_path}"
  zone                     = "${var.zone}"
  db_disk_image            = "${var.db_disk_image}"
  name                     = "reddit-db-prod"
  tags                     = ["prod", "reddit-db"]
  ssh_key_for_provisioners = "${var.ssh_key_for_provisioners}"
}

module "app" {
  deploy                   = "${var.deploy}"
  source                   = "../modules/app"
  public_key_path          = "${var.public_key_path}"
  db_internal_ip           = "${module.db.internal_ip[0]}"
  zone                     = "${var.zone}"
  app_disk_image           = "${var.app_disk_image}"
  name                     = "reddit-app-prod"
  tags                     = ["prod", "reddit-app", "http-server"]
  app_ip_name              = "reddit-app-ip-prod"
  ssh_key_for_provisioners = "${var.ssh_key_for_provisioners}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["1.1.1.1/32"]
}

