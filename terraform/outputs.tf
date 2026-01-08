output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "service_url" {
  description = "URL del endpoint de la Lambda"
  # El splat operator (*) maneja el caso de que la lista esté vacía
  value       = try(aws_lambda_function_url.endpoint[0].function_url, "Pendiente de creación")
}