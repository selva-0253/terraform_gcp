resource "google_compute_subnetwork" "public_subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.cidr
  region        = var.subnet_region
  network       = var.vpc_name
}

