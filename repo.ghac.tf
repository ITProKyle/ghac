module "ghac" {
  source = "./modules/repo"

  auto_init                             = true
  default_branch                        = "master"
  description                           = "GitHub-as-Code using Terraform."
  issue_labels                          = yamldecode(file("./.github/labels.yml"))
  issue_labels_merge_with_github_labels = false
  license_template                      = "apache-2.0"
  name                                  = "ghac"
  visibility                            = "public"
}
