terraform {
  required_version = "~> 1.0"

  backend "remote" {
    organization = "Finley"

    workspaces {
      name = "ghac-ITProKyle"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.18"
    }
  }
}

provider "github" {
  owner = "ITProKyle"
}
