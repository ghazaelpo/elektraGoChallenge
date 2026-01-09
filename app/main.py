def handler(event, context):
    print("Hola desde los logs!") # Esto saldrá en CloudWatch
    return {
        'statusCode': 200,
        'body': 'Hola Mundo, Test case 1'
    }