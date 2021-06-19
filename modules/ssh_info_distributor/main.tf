provider "github" {
  token = var.github_token
  owner = "drakumus"
}

data "github_actions_public_key" "respository_data" {
  repository = var.repository_name
}

resource "github_actions_secret" "ssh_ip_address" {
  repository = var.repository_name
  secret_name = "SSH_IP_ADDRESS"
  plaintext_value = var.ssh_ip_address
}

resource "github_actions_secret" "ssh_private_key" {
  repository = var.repository_name
  secret_name = "SSH_PRIVATE_KEY"
  plaintext_value = var.ssh_private_key
}

resource "github_actions_secret" "ship_it" {
  repository = var.repository_name
  secret_name = "SHIP_IT"
  plaintext_value = var.github_repo_ship_it
}