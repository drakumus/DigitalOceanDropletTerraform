terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "default" {
  name       = "General Accessor"
  public_key = file(var.public_ssh_key)
}

# need variables do_token, private_key for this to work
resource "digitalocean_droplet" "web" {
  image    = "docker-20-04"
  name     = "ProjectServer1"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]

  # working code to connect and execute commands on remote after creation
  # connection exists for provisioner to connect
  #  connection {
  #    host = self.ipv4_address
  #    user = "root"
  #    type = "ssh"
  #    private_key = file(var.private_ssh_key)
  #    timeout = "10m"
  #  }
  #  provisioner "remote-exec" {
  #    inline = [
  #      #"export PATH=$PATH:/usr/bin",
  #      #install nginx
  #      #"sudo apt-get update",
  #      #"sudo apt-get -y install nginx"
  #      "ip address show"
  #    ]
  #  }
}

resource "digitalocean_domain" "default" {
  name = "zoci.me"
}

# Add an A record to the domain for www.example.com.
resource "digitalocean_record" "A" {
  domain = digitalocean_domain.default.name
  type   = "A"
  name   = "@"
  value  = digitalocean_droplet.web.ipv4_address
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.default.name
  type   = "A"
  name   = "www"
  value  = digitalocean_droplet.web.ipv4_address
}

# provider "google-beta" {
#   project     = "zoci-me"
#   credentials = var.google_service_account_key
# }
# 
# resource "google_dns_managed_zone" "parent-zone" {
#   provider = google-beta
#   name        = "dns-zone"
#   dns_name    = "dns-zone.zoci.me."
#   description = "My website"
# }
# 
# resource "google_dns_record_set" "resource-recordset" {
#   provider = google-beta
#   managed_zone = google_dns_managed_zone.parent-zone.name
#   name         = "record.dns-zone.zoci.me."
#   type         = "A"
#   rrdatas      = [digitalocean_droplet.web.ipv4_address]
#   ttl          = 900
# }


# Generate a mobaxterm session file for the above droplet
resource "local_file" "ssh_session_file" {
  # TODO use variable to pass file location of private key here
  content  = "terraform = #109#0%${digitalocean_droplet.web.ipv4_address}%22%root%%-1%-1%%%22%%0%0%0%_ProfileDir_\\Documents\\rsa\\terraform\\project_server%%-1%0%0%0%%1080%%0%0%1#MobaFont%10%0%0%0%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%-1%_Std_Colors_0_%80%24%0%1%-1%<none>%%0#0# #-1"
  filename = "${path.module}/terraform.moba"
}

resource "digitalocean_project" "Personal" {
  name        = "Personal"
  description = "A project to represent development resources."
  purpose     = "Web Application"
  environment = "Development"
  resources   = [digitalocean_droplet.web.urn]
}

module "website_ssh_info_distributor" {
  github_token        = var.github_token
  github_repo_ship_it = var.github_repo_ship_it
  source              = "./modules/ssh_info_distributor"
  repository_name     = "website"
  ssh_ip_address      = digitalocean_droplet.web.ipv4_address
  ssh_private_key     = file(var.private_ssh_key) # for future ref: file function returns a string
}

module "shadow_realm_discord_bot_ssh_info_distributor" {
  github_token        = var.github_token
  github_repo_ship_it = var.github_repo_ship_it
  source              = "./modules/ssh_info_distributor"
  repository_name     = "ShadowRealmDiscordBot"
  ssh_ip_address      = digitalocean_droplet.web.ipv4_address
  ssh_private_key     = file(var.private_ssh_key) # for future ref: file function returns a string
}