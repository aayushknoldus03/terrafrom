
# output "branchkanaam" {
#   value = azuredevops_git_repository.example.default_branch
# }
# output "commit" {
#   value = azuredevops_git_repository_branch.example.last_commit_id
#   sensitive = false
# }
output "service_endpoint_name" {
  value = azuredevops_serviceendpoint_github.github_conn.service_endpoint_name
}