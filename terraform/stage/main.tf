provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

terraform {
  backend "gcs" {
    bucket = "tf-back-stage"
    prefix = "terraform/state"
  }
}

module "app" {
  deploy                   = "${var.deploy}"
  source                   = "../modules/app"
  public_key_path          = "${var.public_key_path}"
  zone                     = "${var.zone}"
  db_internal_ip           = "${module.db.internal_ip[0]}"
  app_disk_image           = "${var.app_disk_image}"
  name                     = "reddit-app-stage"
  tags                     = ["stage", "reddit-app", "http-server"]
  app_ip_name              = "reddit-app-ip-stage"
  ssh_key_for_provisioners = "${var.ssh_key_for_provisioners}"
}

module "db" {
  deploy                   = "${var.deploy}"
  source                   = "../modules/db"
  public_key_path          = "${var.public_key_path}"
  zone                     = "${var.zone}"
  db_disk_image            = "${var.db_disk_image}"
  name                     = "reddit-db-stage"
  tags                     = ["stage", "reddit-db"]
  ssh_key_for_provisioners = "${var.ssh_key_for_provisioners}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["0.0.0.0/0"]
}

