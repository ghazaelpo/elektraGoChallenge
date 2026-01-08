terraform {
  backend "s3" {
    bucket         = "mi-terraform-state-elektrago" # El nombre que creaste arriba
    key            = "hola-mundo/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    # Opcional: dynamodb_table = "terraform-lock" (Para evitar ejecuciones simultáneas)
  }
}

provider "aws" {
  region = var.aws_region
}

variable "create_lambda" {
  type    = bool
  default = false
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
  count         = var.create_lambda ? 1 : 0
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
  count              = var.create_lambda ? 1 : 0
  function_name      = aws_lambda_function.hola_mundo[0].function_name
  authorization_type = "NONE"

  cors {
    allow_origins = ["*"]
  }
}