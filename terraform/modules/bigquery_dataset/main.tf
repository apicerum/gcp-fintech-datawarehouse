resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "${var.dataset_id}_${var.environment}"
  friendly_name               = "${var.friendly_name} (${var.environment})"
  description                 = var.description
  location                    = var.location
  delete_contents_on_destroy  = true

  labels = {
    env = var.environment
  }
}