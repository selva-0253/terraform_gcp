resource "google_compute_subnetwork" "public_subnet" {
  name          = var.subnet1_name
  ip_cidr_range = "10.1.0.0/16"
  region        = var.region
  network       = var.vpc_name
}

