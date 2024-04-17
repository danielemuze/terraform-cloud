# Declare the variable for Google Cloud credentials
variable "GOOGLE_CREDENTIALS" {
  description = "JSON key for GCP service account"
  type        = string
}

# Configure the Google Cloud Provider
provider "google" {
  credentials = var.GOOGLE_CREDENTIALS
  project     = "terraform-cloud-420613"
  region      = "us-central1"
  zone        = "us-central1-c"
}

# Create a Google Compute Engine instance
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-test-instance"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP for Internet access
    }
  }
}

# Output the instance IP
output "instance_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
