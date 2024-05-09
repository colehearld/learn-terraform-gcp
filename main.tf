# Sets up the Google Cloud provider with specific project ID, region, and path to the credentials file.
provider "google" {
  project     = "your-project-id"  # GCP project ID
  region      = "us-central1"               # Default region for resources
  credentials = file("Path/To/terraform-project-key.json") # Path to the JSON key file for authentication
}

# Defines a Google Compute Engine (GCE) firewall rule allowing external SSH connections.
resource "google_compute_firewall" "firewall" {
  name    = "gritfy-firewall-externalssh"  # Name of the firewall rule
  network = "default"                      # Specifies the network the rule applies to
  allow {
    protocol = "tcp"                       # Allows TCP traffic
    ports    = ["22"]                      # Restricts allowed traffic to SSH port 22
  }
  source_ranges = ["0.0.0.0/0"]            # Allows traffic from any IP address
  target_tags   = ["externalssh"]          # Tags VM instances to which the rule will apply
}

# Defines a GCE firewall rule for a web server, allowing HTTP and HTTPS traffic.
resource "google_compute_firewall" "webserverrule" {
  name    = "gritfy-webserver"             
  network = "default"                      
  allow {
    protocol = "tcp"                       
    ports    = ["80", "443"]               # Restricts allowed traffic to ports for HTTP and HTTPS
  }
  source_ranges = ["0.0.0.0/0"]            
  target_tags   = ["webserver"]            
}

# Creates a static public IP address to be used by a compute instance.
resource "google_compute_address" "static" {
  name       = "vm-public-address"         # Name of the IP address resource
  project    = "terraform-project-411316"  # GCP project ID (optional if defined at the provider level)
  region     = "us-central1"               # Region where the IP address is located
  depends_on = [google_compute_firewall.firewall]  # Ensures firewall rules are set before IP is assigned
}

# Defines a GCE instance with basic configurations, startup script, and network settings.
resource "google_compute_instance" "dev" {
  name         = "demovm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  tags         = ["externalssh", "webserver"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts" # Define OS for the VM to use
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  # Firewall provisioned so SSH doesn't fail
  depends_on = [google_compute_firewall.firewall, google_compute_firewall.webserverrule]

  metadata_startup_script = "${file("./learn-terraform-gcp/install_docker.sh")}"
}

output "ip_address" {
  value = google_compute_address.static.address
}

