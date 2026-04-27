terraform {
	backend "gcs"{
		bucket = "terraform-state-2026"
		prefix = "terraform/state"
	}
}
		
