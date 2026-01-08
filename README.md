# Microservicio "Hola Mundo" - AWS Lambda + Terraform

Este repositorio contiene un ejercicio completo de CI/CD para desplegar un microservicio en Python sobre infraestructura AWS, utilizando un enfoque de Infraestructura como Código (IaC).

## 🚀 Arquitectura
- **Backend:** Python nativo (Handler estándar de Lambda).
- **Runtime:** Contenedor Docker basado en la imagen oficial de AWS Lambda.
- **Infraestructura:** Provisionada con Terraform utilizando un backend remoto en S3.
- **Cloud:** AWS Lambda con Function URL (Costo $0 / Free Tier).
- **CI/CD:** GitHub Actions con jobs de despliegue en dos etapas (Infra ECR -> Build -> Infra Lambda).

## 🛠️ Requisitos Previos

1. **AWS CLI** configurado con permisos de Administrador.
2. **Terraform** v1.5.0+ instalado.
3. **Secrets en GitHub:** Configurar los siguientes Secrets en el repositorio:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
4. **Bucket S3:** Crear un bucket manualmente para el backend de Terraform (tfstate).

## 📁 Estructura del Proyecto

- `/app`: Código fuente del microservicio (Handler nativo).
- `/terraform`: Archivos de configuración de infraestructura (con lógica de `count` para creación segura).
- `.github/workflows`: Pipeline de automatización con orquestación de dependencias (`needs`).
- `Dockerfile`: Definición de la imagen optimizada para el Runtime Interface Client de Lambda.

## ⚙️ Despliegue Automático

El despliegue se activa automáticamente al realizar un `push` a la rama `main`. El pipeline realiza:

1. **Infrastructure (Step 1)**: Crea el repositorio ECR y los roles de IAM necesarios.
2. **Build**: Construye la imagen Docker y la sube a Amazon ECR.
3. **Infrastructure (Step 2)**: Ejecuta `terraform apply` activando la creación de la Lambda una vez que la imagen ya existe.

## 🧪 Cómo Probar el Endpoint

Una vez que el pipeline finalice exitosamente:

1. El endpoint se mostrará en los logs del job `deploy-lambda` bajo el nombre `service_url`.
2. También puedes obtenerlo desde la consola de **AWS Lambda** > **Function URL**.
3. Ejecuta un `curl` o ábrelo en tu navegador:

```bash
curl https://<id-de-la-url>.lambda-url.us-east-1.on.aws/