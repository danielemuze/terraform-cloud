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

resource "google_compute_instance_from_machine_image" "tpl" {
  provider = google-beta
  project  = "terraform-cloud-420613"
  name     = format("test-vm-%03d", count.index + 1)  // Name each VM uniquely using count.index
  zone     = "us-west1-a"
  count    = 3  // Specify the number of VMs to create

  source_machine_image = "projects/terraform-cloud-420613/global/machineImages/ubuntu-template"

  // Override fields from machine image
  can_ip_forward = false
}

# Output the private IPs of all instances
output "instance_private_ips" {
  value = [for vm in google_compute_instance_from_machine_image.tpl : vm.network_interface[0].network_ip]
}
