resource "google_compute_instance" "virtual_machine" {

	name = var.vm_name
	machine_type = var.vm_machine_type
  	zone = var.vm_zone
  	network_interface {
  		network = var.network
 		subnetwork = var.subnetwork
  		access_config {
      // Ephemeral public IP
    }
}
	boot_disk {
    	initialize_params {
    	image = var.vm_boot_disk_image
     		labels = {
        	my_label = "value"
    	}
    }
  }
}

