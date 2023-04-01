provider "aws" {
  region = "ca-central-1"
}

provider "vault" {
  address = "https://vault.control.acceleratorlabs.ca"
}
