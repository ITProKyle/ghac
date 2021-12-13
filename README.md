# ghac

GitHub-as-Code using Terraform.

This repo uses Terraform to manage all of my GitHub resources.

## Importing Resources

Resources that already exist need to be imported before they can be managed by Terraform.
Below are some examples for how to import a repo and it's default branch.

```console
# import repo
terraform import module.action_setup_python.github_repository.repository action-setup-python

# import default branch
terraform import "module.generic_template.github_branch_default.default[0]" generic-template
```

Things that don't need to be imported:

- `issue_labels`
