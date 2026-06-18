output "service_account_email" {
  description = "The email address of the created service account"
  value       = google_service_account.sanbodx_sa.email
}

output "service_account_id" {
  description = "The unique ID of the service account"
  value       = google_service_account.sanbodx_sa.unique_id
}

output "service_account_name" {
  description = "The fully-qualified name of the service account"
  value       = google_service_account.sanbodx_sa.name
}
