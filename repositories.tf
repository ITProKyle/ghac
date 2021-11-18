locals {
  issue_labels = yamldecode(file("./.github/labels.yml"))
}

module "action_setup_python" {
  source = "./modules/repo"

  default_branch                        = "master"
  description                           = "A composite action for setting up python."
  issue_labels                          = local.issue_labels
  issue_labels_merge_with_github_labels = false
  name                                  = "action-setup-python"
  visibility                            = "public"
}

module "dot_github" {
  source = "./modules/repo"

  auto_init                             = true
  default_branch                        = "master"
  description                           = "Default GitHub configuration files."
  issue_labels                          = local.issue_labels
  issue_labels_merge_with_github_labels = false
  name                                  = ".github"
  visibility                            = "public"
}

module "generic_template" {
  source = "./modules/repo"

  default_branch                        = "master"
  description                           = "A generic template for GitHub repos. While it is primarily intended for Python project, it can be used as a reference for projects in other languages as well."
  homepage_url                          = "https://generic-template.readthedocs.io"
  is_template                           = true
  issue_labels                          = local.issue_labels
  issue_labels_merge_with_github_labels = false
  name                                  = "generic-template"
  topics = [
    "python",
    "template"
  ]
  visibility = "public"
}

module "ghac" {
  source = "./modules/repo"

  auto_init                             = true
  default_branch                        = "master"
  description                           = "GitHub-as-Code using Terraform."
  issue_labels                          = local.issue_labels
  issue_labels_merge_with_github_labels = false
  license_template                      = "apache-2.0"
  name                                  = "ghac"
  visibility                            = "public"

  branch_protections_v3 = [
    {
      branch         = "master"
      enforce_admins = false
      required_pull_request_reviews = {
        dismiss_stale_reviews = true
      }
      required_status_checks = {
        contexts = [  # must have run at lease once to use
          "Terraform Cloud/Finley/ghac-ITProKyle",
        ]
        strict = false
      }
    }
  ]
}

module "itprokyle" {
  source = "./modules/repo"

  auto_init                             = true
  default_branch                        = "master"
  issue_labels                          = local.issue_labels
  issue_labels_merge_with_github_labels = false
  name                                  = "ITProKyle"
  visibility                            = "public"
}
