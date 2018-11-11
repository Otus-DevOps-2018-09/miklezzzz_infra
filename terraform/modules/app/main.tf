resource "google_compute_instance" "app" {
  name         = "${var.name}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = "${var.tags}"

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    ssh-keys = "shma:${file(var.public_key_path)}"
  }
}

resource "google_compute_address" "app_ip" {
  name = "${var.app_ip_name}"
}

resource "null_resource" "provisioners" {
  count = "${var.deploy}"

  connection {
    type        = "ssh"
    user        = "shma"
    agent       = false
    private_key = "${file(var.ssh_key_for_provisioners)}"
    host        = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
  }

  provisioner "file" {
    source      = "${path.module}/files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'DATABASE_URL=\"${var.db_internal_ip}\"' >> /home/shma/.bash_profile",
      "echo 'export DATABASE_URL' >> /home/shma/.bash_profile",
    ]
  }

  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}

