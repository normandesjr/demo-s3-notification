provider "aws" {
  version                 = "~> 1.36"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "terraform"
  region                  = "us-east-1"
}