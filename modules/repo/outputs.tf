output "collaborators" {
  value       = github_repository_collaborator.collaborator
  description = "A map of collaborator objects keyed by collaborator.name."
}

output "full_name" {
  value       = github_repository.repository.full_name
  description = "A string of the form '<org-name>/<repo-name>'."
}

output "git_clone_url" {
  value       = github_repository.repository.git_clone_url
  description = "URL that can be provided to git clone to clone the repository anonymously via the git protocol."
}

output "html_url" {
  value       = github_repository.repository.html_url
  description = "URL to the repository on the web."
}

output "http_clone_url" {
  value       = github_repository.repository.http_clone_url
  description = "URL that can be provided to git clone to clone the repository via HTTPS."
}

output "issue_labels" {
  value       = github_issue_label.label
  description = "A map of issue labels keyed by label input id or name."
}

output "repository" {
  value       = github_repository.repository
  description = "All attributes and arguments as returned by the github_repository resource."
}

output "ssh_clone_url" {
  value       = github_repository.repository.ssh_clone_url
  description = "URL that can be provided to git clone to clone the repository via SSH."
}
