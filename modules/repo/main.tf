terraform {
  required_version = "~> 1.5"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.38"
    }
  }
}

# Set some opinionated default settings through var.defaults and locals
locals {
  allow_auto_merge       = var.allow_auto_merge == null ? lookup(var.defaults, "allow_auto_merge", false) : var.allow_auto_merge
  allow_merge_commit     = var.allow_merge_commit == null ? lookup(var.defaults, "allow_merge_commit", false) : var.allow_merge_commit
  allow_rebase_merge     = var.allow_rebase_merge == null ? lookup(var.defaults, "allow_rebase_merge", false) : var.allow_rebase_merge
  allow_squash_merge     = var.allow_squash_merge == null ? lookup(var.defaults, "allow_squash_merge", true) : var.allow_squash_merge
  allow_update_branch    = var.allow_update_branch == null ? lookup(var.defaults, "allow_update_branch", true) : var.allow_squash_merge
  auto_init              = var.auto_init == null ? lookup(var.defaults, "auto_init", false) : var.auto_init
  default_branch         = var.default_branch == null ? lookup(var.defaults, "default_branch", null) : var.default_branch
  delete_branch_on_merge = var.delete_branch_on_merge == null ? lookup(var.defaults, "delete_branch_on_merge", true) : var.delete_branch_on_merge
  gitignore_template     = var.gitignore_template == null ? lookup(var.defaults, "gitignore_template", "") : var.gitignore_template
  has_issues             = var.has_issues == null ? lookup(var.defaults, "has_issues", true) : var.has_issues
  has_projects           = var.has_projects == null ? lookup(var.defaults, "has_projects", false) : var.has_projects
  has_wiki               = var.has_wiki == null ? lookup(var.defaults, "has_wiki", false) : var.has_wiki
  homepage_url           = var.homepage_url == null ? lookup(var.defaults, "homepage_url", "") : var.homepage_url
  is_template            = var.is_template == null ? lookup(var.defaults, "is_template", false) : var.is_template
  issue_labels_create    = var.issue_labels_create == null ? lookup(var.defaults, "issue_labels_create", local.issue_labels_create_computed) : var.issue_labels_create
  license_template       = var.license_template == null ? lookup(var.defaults, "license_template", "") : var.license_template
  standard_topics        = var.topics == null ? lookup(var.defaults, "topics", []) : var.topics
  template               = var.template == null ? [] : [var.template]
  topics                 = concat(local.standard_topics, var.extra_topics)
  visibility             = var.visibility == null ? lookup(var.defaults, "visibility", "public") : var.visibility

  issue_labels_create_computed = local.has_issues || length(var.issue_labels) > 0

  # for readability
  gh_labels     = local.var_gh_labels == null ? lookup(var.defaults, "issue_labels_merge_with_github_labels", true) : local.var_gh_labels
  var_gh_labels = var.issue_labels_merge_with_github_labels

  issue_labels_merge_with_github_labels = local.gh_labels
  # Per default, GitHub activates vulnerability  alerts for public repositories and disables it for private repositories
  vulnerability_alerts = var.vulnerability_alerts != null ? var.vulnerability_alerts : local.visibility == "private" ? false : true
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the repository
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
# ---------------------------------------------------------------------------------------------------------------------
resource "github_repository" "repository" {
  allow_auto_merge       = local.allow_auto_merge
  allow_merge_commit     = local.allow_merge_commit
  allow_rebase_merge     = local.allow_rebase_merge
  allow_squash_merge     = local.allow_squash_merge
  allow_update_branch    = local.allow_update_branch
  archive_on_destroy     = var.archive_on_destroy
  archived               = var.archived
  auto_init              = local.auto_init
  delete_branch_on_merge = local.delete_branch_on_merge
  description            = var.description
  gitignore_template     = local.gitignore_template
  has_issues             = local.has_issues
  has_projects           = local.has_projects
  has_wiki               = local.has_wiki
  homepage_url           = local.homepage_url
  is_template            = local.is_template
  license_template       = local.license_template
  name                   = var.name
  topics                 = local.topics
  visibility             = local.visibility
  vulnerability_alerts   = local.vulnerability_alerts

  dynamic "pages" {
    for_each = var.pages != null ? [true] : []

    content {
      source {
        branch = var.pages.branch
        path   = try(var.pages.path, "/")
      }
      cname = try(var.pages.cname, null)
    }
  }

  dynamic "template" {
    for_each = local.template

    content {
      owner      = template.value.owner
      repository = template.value.repository
    }
  }

  lifecycle {
    ignore_changes = [
      auto_init,
      license_template,
      gitignore_template,
      template,
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Set default branch
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default
# ---------------------------------------------------------------------------------------------------------------------
resource "github_branch_default" "default" {
  count = local.default_branch != null ? 1 : 0

  repository = github_repository.repository.name
  branch     = local.default_branch
}

# ---------------------------------------------------------------------------------------------------------------------
# Issue Labels
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # only add to the list of labels even if github removes labels as changing this will affect
  # all deployed repositories.
  # add labels if new labels in github are added by default.
  # this is the set of labels and colors as of 2020-02-02
  github_default_issue_labels = local.issue_labels_merge_with_github_labels ? [
    {
      name        = "bug"
      description = "Something isn't working"
      color       = "d73a4a"
    },
    {
      name        = "documentation"
      description = "Improvements or additions to documentation"
      color       = "0075ca"
    },
    {
      name        = "duplicate"
      description = "This issue or pull request already exists"
      color       = "cfd3d7"
    },
    {
      name        = "enhancement"
      description = "New feature or request"
      color       = "a2eeef" # cspell:ignore a2eeef
    },
    {
      name        = "good first issue"
      description = "Good for newcomers"
      color       = "7057ff"
    },
    {
      name        = "help wanted"
      description = "Extra attention is needed"
      color       = "008672"
    },
    {
      name        = "invalid"
      description = "This doesn't seem right"
      color       = "e4e669"
    },
    {
      name        = "question"
      description = "Further information is requested"
      color       = "d876e3"
    },
    {
      name        = "wontfix"
      description = "This will not be worked on"
      color       = "ffffff"
    }
  ] : []

  github_issue_labels = { for i in local.github_default_issue_labels : i.name => i }

  module_issue_labels = { for i in var.issue_labels : lookup(i, "id", lower(i.name)) => merge({
    description = null
  }, i) }

  issue_labels = merge(local.github_issue_labels, local.module_issue_labels)
}

resource "github_issue_label" "label" {
  for_each = local.issue_labels_create ? local.issue_labels : {}

  repository  = github_repository.repository.name
  name        = each.value.name
  description = each.value.description
  color       = each.value.color
}

# ---------------------------------------------------------------------------------------------------------------------
# Collaborators
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator
# ---------------------------------------------------------------------------------------------------------------------
locals {
  collab_admin    = { for i in var.collaborators_admin : i => "admin" }
  collab_maintain = { for i in var.collaborators_maintain : i => "maintain" }
  collab_pull     = { for i in var.collaborators_pull : i => "pull" }
  collab_push     = { for i in var.collaborators_push : i => "push" }
  collab_triage   = { for i in var.collaborators_triage : i => "triage" }

  collaborators = merge(
    local.collab_admin,
    local.collab_maintain,
    local.collab_pull,
    local.collab_push,
    local.collab_triage,
  )
}

resource "github_repository_collaborator" "collaborator" {
  for_each = local.collaborators

  repository = github_repository.repository.name
  username   = each.key
  permission = each.value
}

# ---------------------------------------------------------------------------------------------------------------------
# Teams by id
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository
# ---------------------------------------------------------------------------------------------------------------------
locals {
  team_id_admin    = [for i in var.teams_admin_ids : { team_id = i, permission = "admin" }]
  team_id_maintain = [for i in var.teams_maintain_ids : { team_id = i, permission = "maintain" }]
  team_id_pull     = [for i in var.teams_pull_ids : { team_id = i, permission = "pull" }]
  team_id_push     = [for i in var.teams_push_ids : { team_id = i, permission = "push" }]
  team_id_triage   = [for i in var.teams_triage_ids : { team_id = i, permission = "triage" }]

  team_ids = concat(
    local.team_id_admin,
    local.team_id_maintain,
    local.team_id_pull,
    local.team_id_push,
    local.team_id_triage,
  )
}

resource "github_team_repository" "team_repository" {
  count = length(local.team_ids)

  repository = github_repository.repository.name
  team_id    = local.team_ids[count.index].team_id
  permission = local.team_ids[count.index].permission
}

# ---------------------------------------------------------------------------------------------------------------------
# Teams by name
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository
# ---------------------------------------------------------------------------------------------------------------------
locals {
  team_admin    = [for i in var.teams_admin : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "admin" }]
  team_maintain = [for i in var.teams_maintain : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "maintain" }]
  team_pull     = [for i in var.teams_pull : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "pull" }]
  team_push     = [for i in var.teams_push : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "push" }]
  team_triage   = [for i in var.teams_triage : { slug = replace(lower(i), "/[^a-z0-9_]/", "-"), permission = "triage" }]

  teams = { for i in concat(
    local.team_admin,
    local.team_maintain,
    local.team_pull,
    local.team_push,
    local.team_triage,
  ) : i.slug => i }
}

resource "github_team_repository" "team_repository_by_slug" {
  for_each = local.teams

  repository = github_repository.repository.name
  team_id    = each.value.slug
  permission = each.value.permission

  depends_on = [var.module_depends_on]
}
