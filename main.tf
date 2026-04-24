module "vpc" {
 
	source = "./modules/vpc"
	vpc_name = var.vpc_name
}

module "vm" {
	source = "./modules/vm"
	
	vm1_name = var.vm1_name
	vm1_zone = var.vm1_zone
  vm1_boot_disk_image = var.vm1_boot_disk_image
  network = module.vpc.vpc_self_link
  vm1_machine_type = var.vm1_machine_type
  subnetwork   = module.subnets.subnet_self_link
}

module "subnets" {
	source = "./modules/subnets"
	
	subnet1_name = var.subnet1_name
  vpc_name = module.vpc.vpc_self_link
  region = var.region
}

module "firewalls" {
  source = "./modules/firewalls"
  
  firewall_name = var.firewall_name
  network  = module.vpc.vpc_self_link
}

