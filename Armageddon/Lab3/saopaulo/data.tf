data "terraform_remote_state" "tokyo" {
  backend = "s3"
  config = {
    bucket = "shinjuku-tf-state"
    key    = "lab3/tokyo.tfstate"
    region = "ap-northeast-1"
  }
}
