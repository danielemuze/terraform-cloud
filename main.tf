variable "GOOGLE_CREDENTIALS" {
  description = "JSON key for GCP service account"
  type        = string
  sensitive   = true
}

provider "google" {
  credentials = var.GOOGLE_CREDENTIALS
  project     = "terraform-cloud-420613"
  region      = "us-west1"
  zone        = "us-west1-a"
}


resource "google_compute_instance" "vm_instance" {
  name         = "terraform-test-instance"
  machine_type = "projects/terraform-cloud-420613/zones/us-west1-a/machineTypes/e2-highcpu-4"

  boot_disk {
    initialize_params {
      # Make sure the image selfLink is correct
      image = "projects/terraform-cloud-420613/global/machineImages/ubuntu-template"
    }
  }

  network_interface {
    network = "default" # Use the default network for the project
    access_config {
      // Ephemeral IP for Internet access
    }
  }
}

# Output the instance IP
output "instance_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
