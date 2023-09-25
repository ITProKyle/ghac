terraform {
  required_version = "~> 1.5"

  backend "remote" {
    organization = "Finley"

    workspaces {
      name = "ghac-ITProKyle"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.38"
    }
  }
}

provider "github" {
  owner = "ITProKyle"
}
