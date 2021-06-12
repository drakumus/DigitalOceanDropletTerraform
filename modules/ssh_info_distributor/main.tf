provider "github" {
  token = var.github_token
  owner = "drakumus"
}

data "github_actions_public_key" "website_key" {
  repository = var.repository_name
  
}

resource "github_actions_secret" "ssh_ip_address" {
  repository = var.repository_name
  secret_name = "ssh_ip_address"
  plaintext_value = var.ssh_ip_address
}

resource "github_actions_secret" "ssh_private_key" {
  repository = var.repository_name
  secret_name = "ssh_private_key"
  plaintext_value = var.ssh_private_key
}