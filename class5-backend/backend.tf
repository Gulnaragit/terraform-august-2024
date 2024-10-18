terraform {
  backend "s3" {
    bucket = "kazien-gulnara"
    key    = "terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "lock-state"
  }
}


