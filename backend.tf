terraform {
  backend "gcs" {
    bucket = "tf-bucket-sandbox"
    prefix = "terraform/state"
  }
}