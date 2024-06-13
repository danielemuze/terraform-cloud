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

resource "google_compute_instance_from_machine_image" "ansible" {
  provider = google-beta
  project  = "terraform-cloud-420613"
  name     = "ansible"
  zone     = "us-west1-a"

  source_machine_image = "projects/terraform-cloud-420613/global/machineImages/ubuntu-template"

  # Override fields from machine image
  can_ip_forward = false
}

# Output the private IP of the Ansible instance
output "ansible_private_ip" {
  value = google_compute_instance_from_machine_image.ansible.network_interface[0].network_ip
}
