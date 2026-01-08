FROM public.ecr.aws/lambda/python:3.9

# Copiamos el código
COPY app/main.py ${LAMBDA_TASK_ROOT}
COPY app/requirements.txt .

# Instalamos dependencias
RUN pip install -r requirements.txt

CMD [ "main.handler" ]