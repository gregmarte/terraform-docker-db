variable "db_name" {
  description = "The name of the PostgreSQL database."
  type        = string
  default     = "property_db"
}

variable "db_user" {
  description = "The username for the PostgreSQL database."
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The password for the PostgreSQL database."
  type        = string
  sensitive   = true # This masks the value in the plan output.
}

variable "docker_container_name" {
  description = "The container name for the PostgreSQL databases"
  type        = string
  default     = "postgres_container"
}