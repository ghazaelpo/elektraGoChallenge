provider "aws" {
  region = var.aws_region
}

# 1. Repositorio ECR
resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.project_name}-repo"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
}

# 2. Rol de IAM para Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# 3. Función Lambda (Usa la imagen de ECR)
resource "aws_lambda_function" "hola_mundo" {
  function_name = "${var.project_name}-function"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.app_repo.repository_url}:latest"

  # Esto es para que no falle si la imagen aún no existe en el primer apply
  lifecycle {
    ignore_changes = [image_uri]
  }
}

# 4. URL Pública para la Lambda (Gratis y sin autenticación para el ejercicio)
resource "aws_lambda_function_url" "endpoint" {
  function_name      = aws_lambda_function.hola_mundo.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = ["*"]
  }
}