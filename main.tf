module "vpc" {
 
	source = "./modules/vpc"
	vpc_name = "website-vpc"
}

module "cluster1_vpc"{

  source = "./modules/vpc"
  vpc_name = "cluster1-vpc"
}

module "subnet1"{
  source = "./modules/subnets"
  subnet_name = "public-subnet"
  cidr = "10.1.0.0/16"
  subnet_region = "asia-south1"
  vpc_name = module.vpc.vpc_self_link
}
module "cluster1_subnet"{
  source = "./modules/subnets"
  subnet_name = "cluster1-subnet"
  cidr = "10.0.0.0/24"
  subnet_region = "asia-south2"
  vpc_name = module.cluster1_vpc.vpc_self_link
}
module "website" {
	source = "./modules/vm"
	
	vm_name = "website-vm"
	vm_zone = "asia-south1-a"
  vm_boot_disk_image = "debian-cloud/debian-12"
  network = module.vpc.vpc_self_link
  vm_machine_type = "e2-micro"
  subnetwork   = module.subnet1.subnet_self_link
}

module "c1_control_plane"{
  source = "./modules/vm"
  vm_name = "c1-cp"
	vm_zone = "asia_south2-a"
  vm_boot_disk_image = "debian-cloud/debian-12"
  network = module.cluster1_vpc.vpc_self_link
  vm_machine_type = "e2-medium"
  subnetwork   = module.cluster1_subnet.subnet_self_link
}

module "c1_worker_node1"{
  source = "./modules/vm"
  vm_name = "c1-wn1"
	vm_zone = "asia_south2-a"
  vm_boot_disk_image = "debian-cloud/debian-12"
  network = module.cluster1_vpc.vpc_self_link
  vm_machine_type = "e2-medium"
  subnetwork   = module.cluster1_subnet.subnet_self_link
}

module "c1_worker_node2"{
  source = "./modules/vm"
  vm_name = "c1-wn2"
	vm_zone = "asia_south2-a"
  vm_boot_disk_image = "debian-cloud/debian-12"
  network = module.cluster1_vpc.vpc_self_link
  vm_machine_type = "e2-medium"
  subnetwork   = module.cluster1_subnet.subnet_self_link
}

# --- Web Firewall ---
module "web_firewalls" {
  source        = "./modules/firewalls"
  firewall_name = "website-firewall"
  network       = module.vpc.vpc_self_link
  
  firewall_rules = {
    "web-access" = {
      protocol = "tcp"
      ports    = ["80", "443", "22"]
      ranges   = ["0.0.0.0/0"]
      tags     = ["web"]
    }
  }
}

# --- Cluster Firewall ---
module "cluster_firewalls" {
  source        = "./modules/firewalls"
  firewall_name = "cluster-fw"
  network       = module.cluster1_vpc.vpc_self_link
  
  firewall_rules = {
    "k8s-internal" = {
      protocol = "tcp"
      ports    = ["0-65535"]
      ranges   = ["10.0.0.0/8"]
    },
    "k8s-nodeport" = {
      protocol = "tcp"
      ports    = ["30000-32767"]
      ranges   = ["0.0.0.0/0"]
    }
    "ssh-access" = {
      protocol = "tcp"
      ports    = ["22"]
      # SECURITY TIP: Replace 0.0.0.0/0 with your actual IP address/32
      # Or your office/VPN CIDR range. Never expose SSH to the whole world.
      ranges   = ["0.0.0.0/0"]
    }
  }
}

# --- Storage Bucket ---

module "storage" {
  source        = "./modules/storage"
  bucket_name   = "my-unique-bucket-name-12345"
  location      = "ASIA-SOUTH1"
  storage_class = "STANDARD"
  force_destroy = false
  labels = {
    env = "prod"
    owner = "team"
  }
}

