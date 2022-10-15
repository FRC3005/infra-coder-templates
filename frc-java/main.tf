terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "0.5.2"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.22.0"
    }
  }
}

locals {
  repo_names = tomap({
    "base"        = "",
    "rapid-react" = "Rapid-React-2022"
  })

  org_name = "FRC3005"
  repo     = lookup(local.repo_names, var.repo_selection, "")
}

variable "repo_selection" {
  description = "What Docker image would you like to use for your workspace?"
  default     = "rapid-react"

  # List of images available for the user to choose from.
  # Delete this condition to give users free text input.
  validation {
    condition     = contains(["base", "rapid-react"], var.repo_selection)
    error_message = "Invalid Docker image!"
  }
}

data "coder_provisioner" "me" {
}

provider "docker" {
  host     = "ssh://will@100.109.152.19"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

data "coder_workspace" "me" {
}

resource "coder_agent" "main" {
  arch           = data.coder_provisioner.me.arch
  os             = "linux"
  startup_script = <<EOF
    #!/bin/sh
    # install and start code-server
    curl -fsSL https://code-server.dev/install.sh | sh
    find $WPILIB_BASE/vsCodeExtensions/ -name "*.vsix" | xargs -I {} code-server --install-extension {}

    # clone repo
    mkdir -p /home/$USER/.ssh
    ssh-keyscan -t rsa github.com >> /home/$USER/.ssh/known_hosts
    git clone --progress git@github.com:FRC3005/${local.repo}.git

    # Start server
    code-server --auth none
    EOF

  # These environment variables allow you to make Git commits right away after creating a
  # workspace. Note that they take precedence over configuration defined in ~/.gitconfig!
  # You can remove this block if you'd prefer to configure Git manually or using
  # dotfiles. (see docs/dotfiles.md)
  env = {
    GIT_AUTHOR_NAME     = "${data.coder_workspace.me.owner}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.me.owner}"
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.me.owner_email}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.me.owner_email}"
  }
}

resource "coder_app" "code-server" {
  agent_id = coder_agent.main.id
  url      = "http://localhost:8080/?folder=/home/coder/${local.repo}"
  icon     = "/icon/code.svg"

  healthcheck {
    url       = "http://localhost:8080/healthz"
    interval  = 3
    threshold = 10
  }
}

resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-root"
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  #image = "codercom/code-server:latest"
  image = "ghcr.io/frc3005/frc-java-${var.repo_selection}:main"
  # Uses lower() to avoid Docker restriction on container names.
  name     = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"
  hostname = lower(data.coder_workspace.me.name)
  dns      = ["1.1.1.1"]
  # Use the docker gateway if the access URL is 127.0.0.1
  entrypoint = ["sh", "-c", replace(coder_agent.main.init_script, "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]
  env        = ["CODER_AGENT_TOKEN=${coder_agent.main.token}"]

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  volumes {
    container_path = "/home/coder/"
    volume_name    = docker_volume.home_volume.name
    read_only      = false
  }
}
