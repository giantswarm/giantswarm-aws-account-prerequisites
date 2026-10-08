terraform {
  # Required by `lifecycle.destroy`
  required_version = ">= 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.81.0, < 7.0.0"
    }
  }
}
