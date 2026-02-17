terraform {
backend "s3" {
bucket = "liberdade-tf-state"
key = "lab3/saopaulo.tfstate"
region = "sa-east-1"
}
}