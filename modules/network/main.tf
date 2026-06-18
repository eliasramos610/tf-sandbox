module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 18.1"

    project_id   = var.project_id
    network_name = "sandbox-network"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
        }
    ]

}