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

# Create a Google Compute Engine instance using the custom machine image
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-test-instance"
  machine_type = "e2-highcpu-4" # Update the machine type to match your template

  boot_disk {
    # Reference the custom machine image using its self-link.
    initialize_params {
      image = "projects/terraform-cloud-420613/global/machineImages/ubuntu-template"
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
