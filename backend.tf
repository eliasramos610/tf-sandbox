# FOR BUCKET ONE 

terraform {
  backend "gcs" {
    bucket = "tf-bucket-sandbox"
    prefix = "terraform/state"
  }
}


# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }