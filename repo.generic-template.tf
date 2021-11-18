module "generic_template" {
  source = "./modules/repo"

  default_branch                        = "master"
  description                           = "A generic template for GitHub repos. While it is primarily intended for Python project, it can be used as a reference for projects in other languages as well."
  homepage_url                          = "https://generic-template.readthedocs.io"
  is_template                           = true
  issue_labels                          = yamldecode(file("./.github/labels.yml"))
  issue_labels_merge_with_github_labels = false
  name                                  = "generic-template"
  topics = [
    "python",
    "template"
  ]
  visibility = "public"
}
