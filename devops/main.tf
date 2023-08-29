terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
  }
}

provider "azuredevops" {
  personal_access_token = var.personal_access_token
  org_service_url       = "https://dev.azure.com/aayushbisht0173"
}

resource "azuredevops_project" "example" {
  name               = "Example Project"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Basic"
}
resource "azuredevops_git_repository" "example-import" {
  project_id = azuredevops_project.example.id
  name       = "github-repo"
  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = var.source_url
  }
}
resource "azuredevops_serviceendpoint_github" "github_conn" {
    project_id             = azuredevops_project.example.id
    service_endpoint_name  = var.service_endpoint_name
   auth_personal {
    personal_access_token = var.github_pat
 
}
}

resource "azuredevops_build_definition" "example" {
  project_id = azuredevops_project.example.id
  name       = "Example Build Definition"
  agent_pool_name = "ubuntupool"
    ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = "aayushknoldus03/jenkinsdemoproject"
    branch_name           = "main"
    yml_path              = "azure-pipeline.yml"
    service_connection_id = azuredevops_serviceendpoint_github.github_conn.id
  }

#   schedules {
#     branch_filter {
#       include = ["main"]
#       exclude = ["test", "regression"]
#     }
#     days_to_build                = ["Sun", "Mon", "Tue", "Wed", "Sat"]
#     schedule_only_with_changes = true
#     start_hours                = 10
#     start_minutes              = 59
#     time_zone                  = "(UTC) Coordinated Universal Time"
#   }
}