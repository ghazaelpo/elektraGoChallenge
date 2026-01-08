# Microservicio "Hola Mundo" - AWS App Runner + Terraform

Este repositorio contiene un ejercicio completo de CI/CD para desplegar un microservicio en Python sobre infraestructura AWS, utilizando un enfoque de Infraestructura como Código (IaC).

## 🚀 Arquitectura
- **Backend:** Python (Flask) retornando un JSON.
- **Runtime:** Contenedor Docker (Python-slim).
- **Infraestructura:** Provisionada con Terraform.
- **Cloud:** AWS App Runner (Serverless Container Service).
- **CI/CD:** GitHub Actions con jobs modulares (Build -> Infra -> Deploy).

## 🛠️ Requisitos Previos

1. **AWS CLI** configurado con permisos de Administrador.
2. **Terraform** v1.5.0+ instalado.
3. **Secrets en GitHub:** Configurar los siguientes Secrets en el repositorio:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

## 📁 Estructura del Proyecto

- `/app`: Código fuente del microservicio.
- `/terraform`: Archivos de configuración de infraestructura.
- `.github/workflows`: Pipeline de automatización.
- `Dockerfile`: Definición de la imagen del contenedor.

## ⚙️ Despliegue Automático

El despliegue se activa automáticamente al realizar un `push` a la rama `main`. El pipeline realiza:

1. **Build**: Construye la imagen Docker y la sube a Amazon ECR.
2. **Infrastructure**: Ejecuta `terraform apply` para crear/actualizar los recursos en AWS.
3. **Deploy**: Fuerza la actualización del servicio App Runner para servir la última imagen.

## 🧪 Cómo Probar el Endpoint

Una vez que el pipeline finalice exitosamente:

1. Ve a la consola de **AWS App Runner**.
2. Selecciona el servicio `hola-mundo-service`.
3. Copia la **Default domain URL**.
4. Ejecuta un `curl` o ábrelo en tu navegador:

```bash
curl https://<id-del-servicio>.<region>[.awsapprunner.com/](https://.awsapprunner.com/)