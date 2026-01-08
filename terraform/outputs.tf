output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "service_url" {
  description = "URL del endpoint de la Lambda"
  value       = aws_lambda_function_url.endpoint.function_url
}