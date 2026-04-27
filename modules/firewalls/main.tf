resource "google_compute_firewall" "dynamic_firewall" {
  # This creates one resource for every rule in the 'firewall_rules' map
  for_each = var.firewall_rules

  name    = "${var.firewall_name}-${each.key}" # e.g., website-firewall-allow-ssh
  network = var.network

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }

  source_ranges = each.value.ranges
  
  # Only applies the tag if it's defined in the map, otherwise it stays null
  target_tags   = lookup(each.value, "tags", null)
}

