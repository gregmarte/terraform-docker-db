terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6.2"
    }
  }
}

# Provider configuration.
provider "docker" {
  host     = "unix:///var/run/docker.sock"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=~/.ssh"]
}

# Pull the PostgreSQL Docker image.
resource "docker_image" "postgres" {
  name = "postgres:latest"
}

# Create a Docker container for the database.
resource "docker_container" "postgres_db" {
  name  = "${var.docker_container_name}"
  image = docker_image.postgres.name

  # Expose the PostgreSQL port.
  ports {
    internal = 5432
    external = 5432
  }

  # Set environment variables for the database.
  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
  ]

  # Set a volume to persist data even if the container is stopped or removed.
  volumes {
    host_path = "/Users/Shared/Databases/postgres-data"
    container_path = "/var/lib/postgresql/data"
  }

  # This ensures the container stays running.
  must_run = true

  # This ensures the container is recreated if the image changes.
  restart = "always"

  # Wait for the database to be ready before proceeding.
  # This is a common and important step to ensure subsequent commands don't fail.
  provisioner "local-exec" {
    command = "until podman exec ${var.docker_container_name} pg_isready; do sleep 1; done"
  }

  # This provisioner runs the SQL script to create the inventory table.
  provisioner "local-exec" {
    command = "cat ./init.sql | podman exec ${var.docker_container_name} psql -U ${var.db_user} -d ${var.db_name}"
  }

  # Ignore changes that cause a replacement on consequentive applies.
  lifecycle {
    ignore_changes = [
      image,
      pid_mode,
      ulimit,
    ]
  }
}
