provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_project_metadata" "project" {
  metadata {
    ssh-keys = <<EOF
shma:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCz7jYekQg6FbVifGGxcYnFO1VHtww2fUw2TzA/qio8jSqEChzjNTWhyoexiBdj/gmvX2R+eylzzJ3ZwSPK1L5VUEieLw17JSuHdmrYLVTABlea9pciwn3ZD8Na7cULeZvKHNqJXUSthnztMqgUW8obeWFlTDD3UNTXc1keTP5MIbPTeSiH7JkdA9dXZkDhUex9i253bwEq67zCkPEtVaHHhFmpAj2B3za06nJ83p2yKldxyBcGAq0fNx6Lm4jOlZerNh73i1RLLAjKWh7Is3d0DpBi8JxX9whAYalvFKY6Y1TNK/CdvnuSD090EIK37T8Gvt2zpbKUAEeA66pUSmWZ shma
appuser:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCz7jYekQg6FbVifGGxcYnFO1VHtww2fUw2TzA/qio8jSqEChzjNTWhyoexiBdj/gmvX2R+eylzzJ3ZwSPK1L5VUEieLw17JSuHdmrYLVTABlea9pciwn3ZD8Na7cULeZvKHNqJXUSthnztMqgUW8obeWFlTDD3UNTXc1keTP5MIbPTeSiH7JkdA9dXZkDhUex9i253bwEq67zCkPEtVaHHhFmpAj2B3za06nJ83p2yKldxyBcGAq0fNx6Lm4jOlZerNh73i1RLLAjKWh7Is3d0DpBi8JxX9whAYalvFKY6Y1TNK/CdvnuSD090EIK37T8Gvt2zpbKUAEeA66pUSmWZ appuser
superuser:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCz7jYekQg6FbVifGGxcYnFO1VHtww2fUw2TzA/qio8jSqEChzjNTWhyoexiBdj/gmvX2R+eylzzJ3ZwSPK1L5VUEieLw17JSuHdmrYLVTABlea9pciwn3ZD8Na7cULeZvKHNqJXUSthnztMqgUW8obeWFlTDD3UNTXc1keTP5MIbPTeSiH7JkdA9dXZkDhUex9i253bwEq67zCkPEtVaHHhFmpAj2B3za06nJ83p2yKldxyBcGAq0fNx6Lm4jOlZerNh73i1RLLAjKWh7Is3d0DpBi8JxX9whAYalvFKY6Y1TNK/CdvnuSD090EIK37T8Gvt2zpbKUAEeA66pUSmWZ superuser
EOF
  }

  project = "infra-219406"
}

resource "google_compute_instance" "app" {
  name         = "reddit-app-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]
  count        = "2"

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  connection {
    type        = "ssh"
    user        = "shma"
    agent       = false
    private_key = "${file("${var.ssh_key_for_provisioners}")}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }

  metadata {
    ssh-keys = "shma:${file("${var.public_key_path}")}"
  }

  network_interface {
    network       = "default"
    access_config = {}
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}

