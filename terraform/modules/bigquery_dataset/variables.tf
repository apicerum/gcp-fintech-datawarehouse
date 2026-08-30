variable "dataset_id" {
  description = "ID del dataset en BigQuery"
  type        = string
}

variable "friendly_name" {
  description = "Nombre descriptivo del dataset"
  type        = string
}

variable "description" {
  description = "Descripción del dataset"
  type        = string
}

variable "location" {
  description = "Región de GCP"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Entorno (dev, prod)"
  type        = string
}