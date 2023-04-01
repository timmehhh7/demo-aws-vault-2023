terraform {
  backend "s3" {
    bucket = "demo-aws-vault-2023-state"
    key    = "stage-3"
    region = "ca-central-1"
  }
}