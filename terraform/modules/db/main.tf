resource "google_compute_instance" "db" {
  name         = "${var.name}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = "${var.tags}"

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata {
    ssh-keys = "shma:${file(var.public_key_path)}"
  }
}

resource "null_resource" "provisioners" {
  count = "${var.deploy}"

  connection {
    type        = "ssh"
    user        = "shma"
    agent       = false
    private_key = "${file(var.ssh_key_for_provisioners)}"
    host        = "${google_compute_instance.db.network_interface.0.access_config.0.nat_ip}"
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}

