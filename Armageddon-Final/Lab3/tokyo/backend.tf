terraform {
  backend "s3" {
    bucket         = "shinjuku-tf-state"    # <-- you create this
    key            = "lab-3/tokyo/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "shinjuku-tf-locks"    # <-- you create this
    encrypt        = true
  }
}
