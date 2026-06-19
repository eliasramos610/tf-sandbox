variable "project_id" {
  description = "The GCP project ID where the service account will be created"
  type        = string
}

variable "my_public_ip" {
    type = string
    description = "my local ip address at home cll navarra"
  
}

variable "tf-bucket" {
    type = string
    description = "Bucket name to be used for terraform state"
  
}

variable "ip_all" {
    type = string
    description = "all world ips"
}