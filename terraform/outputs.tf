output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "service_url" {
  description = "La URL del endpoint para probar el 'Hola Mundo'"
  value       = "https://${aws_apprunner_service.service.service_url}"
}