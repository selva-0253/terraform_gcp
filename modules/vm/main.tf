resource "google_compute_instance" "vm1" {

	name = var.vm1_name
	machine_type = var.vm1_machine_type
  zone = var.vm1_zone
  network_interface {
  network = var.network
  subnetwork = var.subnetwork
  access_config {
      // Ephemeral public IP
    }
}
	  boot_disk {
    		initialize_params {
      		image = var.vm1_boot_disk_image
      		labels = {
        	my_label = "value"
      		}
    	}
  }
}
