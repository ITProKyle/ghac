# wrapper for https://registry.terraform.io/providers/integrations/github/latest/docs
variable "allow_auto_merge" {
  description = "(Optional) Set to `true` to allow auto-merging pull requests on the repository. (Default: false)"
  type        = bool
  default     = null
}
variable "allow_merge_commit" {
  description = "(Optional) Set to false to disable merge commits on the repository. (Default: false)"
  type        = bool
  default     = null
}

variable "allow_rebase_merge" {
  description = "(Optional) Set to true to enable rebase merges on the repository. (Default: false)"
  type        = bool
  default     = null
}

variable "allow_squash_merge" {
  description = "(Optional) Set to true to enable squash merges on the repository. (Default: false)"
  type        = bool
  default     = null
}

variable "allow_update_branch" {
  description = "(Optional) - Set to true to always suggest updating pull request branches. (Default: true)"
  type        = bool
  default     = null
}

variable "archive_on_destroy" {
  type        = string
  description = "(Optional) Set to `false` to not archive the repository instead of deleting on destroy."
  default     = true
}

variable "archived" {
  description = "(Optional) Specifies if the repository should be archived. (Default: false)"
  type        = bool
  default     = false
}

variable "auto_init" {
  description = "(Optional) Wether or not to produce an initial commit in the repository. (Default: false)"
  type        = bool
  default     = null
}

variable "collaborators_admin" {
  description = "(Optional) A list of users to add as collaborators granting them admin (full) permission."
  type        = list(string)
  default     = []
}

variable "collaborators_maintain" {
  description = "(Optional) A list of users to add as collaborators granting them maintain permission."
  type        = list(string)
  default     = []
}

variable "collaborators_pull" {
  description = "(Optional) A list of users to add as collaborators granting them pull (read-only) permission."
  type        = list(string)
  default     = []
}

variable "collaborators_push" {
  description = "(Optional) A list of users to add as collaborators granting them push (read-write) permission."
  type        = list(string)
  default     = []
}

variable "collaborators_triage" {
  description = "(Optional) A list of users to add as collaborators granting them triage permission."
  type        = list(string)
  default     = []
}

variable "default_branch" {
  description = "(Optional) The name of the default branch of the repository. NOTE: This can only be set after a repository has already been created, and after a correct reference has been created for the target branch inside the repository. This means a user will have to omit this parameter from the initial repository creation and create the target branch inside of the repository prior to setting this attribute."
  type        = string
  default     = null
}

variable "defaults" {
  description = "(Optional) Overwrite defaults for various repository settings"
  type        = any

  # Example:
  # defaults = {
  #   homepage_url           = "https://mineiros.io/"
  #   visibility             = "private"
  #   has_issues             = false
  #   has_projects           = false
  #   has_wiki               = false
  #   delete_branch_on_merge = true
  #   allow_merge_commit     = true
  #   allow_rebase_merge     = false
  #   allow_squash_merge     = false
  #   has_downloads          = false
  #   auto_init              = true
  #   gitignore_template     = "terraform"
  #   license_template       = "mit"
  #   default_branch         = "main"
  #   topics                 = ["topic-1", "topic-2"]
  # }

  default = {}
}

variable "delete_branch_on_merge" {
  description = "(Optional) Whether or not to delete the merged branch after merging a pull request. (Default: true)"
  type        = bool
  default     = null
}

variable "description" {
  description = "(Optional) A description of the repository."
  type        = string
  default     = ""
}

variable "extra_topics" {
  description = "(Optional) The list of additional topics of the repository. (Default: [])"
  type        = list(string)
  default     = []
}

variable "gitignore_template" {
  description = "(Optional) Use the name of the template without the extension. For example, Haskell. Available templates: https://github.com/github/gitignore"
  type        = string
  default     = null
}

variable "has_issues" {
  description = "(Optional) Set to true to enable the GitHub Issues features on the repository. (Default: true)"
  type        = bool
  default     = null
}

variable "has_projects" {
  description = "(Optional) Set to true to enable the GitHub Projects features on the repository. Per the github documentation when in an organization that has disabled repository projects it will default to false and will otherwise default to true. If you specify true when it has been disabled it will return an error.  (Default: false)"
  type        = bool
  default     = null
}

variable "has_wiki" {
  description = "(Optional) Set to true to enable the GitHub Wiki features on the repository. (Default: false)"
  type        = bool
  default     = null
}

variable "homepage_url" {
  description = "(Optional) The website of the repository."
  type        = string
  default     = null
}

variable "is_template" {
  description = "(Optional) Whether or not to tell GitHub that this is a template repository. ( Default: false)"
  type        = bool
  default     = null
}

variable "issue_labels" {
  description = "(Optional) Configure a GitHub issue label resource."
  type = list(object({
    color       = string
    description = string
    name        = string
  }))

  # Example:
  # issue_labels = [
  #   {
  #     name        = "WIP"
  #     description = "Work in Progress..."
  #     color       = "d6c860"
  #   },
  #   {
  #     name        = "another-label"
  #     description = "This is a label created by Terraform..."
  #     color       = "1dc34f"
  #   }
  # ]

  default = []
}

variable "issue_labels_create" {
  description = "(Optional) Specify whether you want to force or suppress the creation of issues labels."
  type        = bool
  default     = null
}

variable "issue_labels_merge_with_github_labels" {
  description = "(Optional) Specify if you want to merge and control Github's default set of issue labels."
  type        = bool
  default     = null
}

variable "license_template" {
  description = "(Optional) Use the name of the template without the extension. For example, 'mit' or 'mpl-2.0'. Available licenses: https://github.com/github/choosealicense.com/tree/gh-pages/_licenses"
  type        = string
  default     = null
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) Define resources this module indirectly depends_on."
  default     = []
}

variable "name" {
  description = "(Required) The name of the repository."
  type        = string
}

variable "pages" {
  description = "(Optional) The repository's GitHub Pages configuration. (Default: {})"
  type = object({
    branch = string
    path   = string
    cname  = string
  })
  default = null
}

variable "template" {
  description = "(Optional) Template repository to use. (Default: {})"
  type = object({
    owner      = string
    repository = string
  })
  default = null
}

variable "teams_admin" {
  description = "(Optional) A list of teams (by name/slug) to grant admin (full) permission to."
  type        = list(string)
  default     = []
}

variable "teams_admin_ids" {
  description = "(Optional) A list of teams (by id) to grant admin (full) permission to."
  type        = list(string)
  default     = []
}

variable "teams_maintain" {
  description = "(Optional) A list of teams (by name/slug) to grant maintain permission to."
  type        = list(string)
  default     = []
}

variable "teams_maintain_ids" {
  description = "(Optional) A list of teams (by id) to grant maintain permission to."
  type        = list(string)
  default     = []
}

variable "teams_pull" {
  description = "(Optional) A list of teams (by name/slug) to grant pull (read-only) permission to."
  type        = list(string)
  default     = []
}

variable "teams_pull_ids" {
  description = "(Optional) A list of teams (by id) to grant pull (read-only) permission to."
  type        = list(string)
  default     = []
}

variable "teams_push" {
  description = "(Optional) A list of teams (by name/slug) to grant push (read-write) permission to."
  type        = list(string)
  default     = []
}

variable "teams_push_ids" {
  description = "(Optional) A list of teams (by id) to grant push (read-write) permission to."
  type        = list(string)
  default     = []
}

variable "teams_triage" {
  description = "(Optional) A list of teams (by name/slug) to grant triage permission to."
  type        = list(string)
  default     = []
}

variable "teams_triage_ids" {
  description = "(Optional) A list of teams (by id) to grant triage permission to."
  type        = list(string)
  default     = []
}

variable "topics" {
  description = "(Optional) The list of topics of the repository.  (Default: [])"
  type        = list(string)
  default     = null
}

variable "visibility" {
  description = "(Optional) Can be 'public', 'private' or 'internal' (GHE only).The visibility parameter overrides the private parameter. Defaults to 'private' if neither private nor visibility are set, default to state of private parameter if it is set."
  type        = string
  default     = null
}

variable "vulnerability_alerts" {
  type        = bool
  description = "(Optional) Set to `false` to disable security alerts for vulnerable dependencies. Enabling requires alerts to be enabled on the owner level."
  default     = null
}
