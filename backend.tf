terraform {
  backend "s3" {
    bucket         = "uniquenameintra-demo"   # replace later
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"       # optional, for state locking
    encrypt        = true
  }
}

