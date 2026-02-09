terraform {
  backend "s3" {
    bucket = "shinjuku-tf-state"
    key    = "lab3/tokyo.tfstate"
    region = "ap-northeast-1"
  }
}