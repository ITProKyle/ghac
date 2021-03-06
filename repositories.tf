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

module "dotfiles" {
  source = "./modules/repo"

  auto_init                             = true
  default_branch                        = "master"
  description                           = "My collection of dotfiles."
  issue_labels                          = local.issue_labels
  issue_labels_merge_with_github_labels = false
  license_template                      = "apache-2.0"
  name                                  = "dotfiles"
  topics = [
    "chezmoi",
    "dotfiles",
    "zsh"
  ]
  visibility = "public"
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

module "pre_commit_hook_yamlfmt" {
  source = "./modules/repo"

  default_branch                        = "master"
  description                           = "YAML formatter for http://pre-commit.com"
  issue_labels                          = local.issue_labels
  issue_labels_merge_with_github_labels = false
  name                                  = "pre-commit-hook-yamlfmt"
  topics = [
    "pre-commit",
  ]
  visibility = "public"
}

module "ssm_dox" {
  source = "./modules/repo"

  auto_init                             = true
  default_branch                        = "master"
  description                           = "CLI tool for building and publishing SSM Documents."
  homepage_url                          = "https://ssm-dox.readthedocs.io"
  issue_labels                          = local.issue_labels
  issue_labels_merge_with_github_labels = false
  name                                  = "ssm-dox"
  topics = [
    "aws",
    "cli",
    "ssm-document",
  ]
  visibility = "public"
}
