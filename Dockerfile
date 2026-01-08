FROM public.ecr.aws/lambda/python:3.9

COPY app/main.py ${LAMBDA_TASK_ROOT}

# No instalamos nada porque no hay dependencias
CMD [ "main.handler" ]