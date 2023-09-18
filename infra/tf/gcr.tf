resource "google_artifact_registry_repository" "airflow_repo" {
  location      = var.region
  repository_id = "airflow"
  description   = "airflow repo"
  format        = "DOCKER"
}