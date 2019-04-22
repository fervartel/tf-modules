variable name {
  default = "tf-vm"
}
variable machine_type {
  default = "f1-micro"
}
variable image {
  default = "debian-cloud/debian-9"
}
# variable vpc {} # To use only if creating a VM using a vpc with 'auto_create_subnetworks = True'
variable subnet {}
variable ssh_user {}
variable ssh_pub_key_file {}