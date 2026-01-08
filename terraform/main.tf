provider "aws" {
  region = var.aws_region
}

# 1. Repositorio ECR para la imagen de Python
resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.project_name}-repo"
  force_delete         = true # Para que el ejercicio sea fácil de limpiar
  image_tag_mutability = "MUTABLE"
}

# 2. IAM Role para que App Runner acceda a ECR
resource "aws_iam_role" "apprunner_service_role" {
  name = "${var.project_name}-apprunner-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr_policy" {
  role       = aws_iam_role.apprunner_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

# 3. Servicio App Runner (El microservicio)
resource "aws_apprunner_service" "service" {
  service_name = "${var.project_name}-service"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_service_role.arn
    }
    image_repository {
      image_identifier      = "${aws_ecr_repository.app_repo.repository_url}:latest"
      image_repository_type = "ECR"
      image_configuration {
        port = "8080"
        runtime_environment_variables = {
          "ENV" = "production"
        }
      }
    }
    auto_deployments_enabled = false
  }

  instance_configuration {
    cpu    = "0.25 vCPU"
    memory = "0.5 GB"
  }

  tags = {
    Name = var.project_name
  }

  # Importante: Esto evita errores si la imagen aún no existe en el primer 'apply'
  depends_on = [aws_iam_role_policy_attachment.apprunner_ecr_policy]
}