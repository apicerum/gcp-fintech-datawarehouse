terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. Dataset RAW (Ingesta)
module "raw_dataset" {
  source        = "../../modules/bigquery_dataset"
  dataset_id    = "fintech_raw"
  friendly_name = "Fintech Raw Data"
  description   = "Capa de ingesta cruda de transacciones"
  location      = var.region
  environment   = "dev"
}

# 2. Dataset STAGING (dbt)
module "staging_dataset" {
  source        = "../../modules/bigquery_dataset"
  dataset_id    = "fintech_staging"
  friendly_name = "Fintech Staging Data"
  description   = "Capa intermedia de limpieza dbt"
  location      = var.region
  environment   = "dev"
}

# 3. Dataset MARTS (Kimball DWH)
module "marts_dataset" {
  source        = "../../modules/bigquery_dataset"
  dataset_id    = "fintech_marts"
  friendly_name = "Fintech Data Marts"
  description   = "Modelo en Estrella para Looker Studio"
  location      = var.region
  environment   = "dev"
}