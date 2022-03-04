terraform {
  cloud {
    organization = "CONIX"
    workspaces {
      name = "China-LAB"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.46.0"
    }

    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = "2.21.0-6.6.ga"
    }
    aws = {
      source = "hashicorp/aws"
    }
    alicloud = {
      source  = "aliyun/alicloud"
    }
  }
}
