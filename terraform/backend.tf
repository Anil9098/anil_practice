terraform {
  backend "s3" {
    bucket = "terra-bucket666"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

