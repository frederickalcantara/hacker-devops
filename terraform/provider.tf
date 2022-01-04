terraform {
    required_providers {
      linode = {
          source = "linode/linode"
          version = "1.25.0"
      }
    }
}

provider "linode" {
  token = var.linode_api_token
}

