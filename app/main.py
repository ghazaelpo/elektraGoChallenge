from flask import Flask
from mangum import Mangum # Este es el adaptador para Lambda

app = Flask(__name__)

@app.route('/')
def hello():
    return {"message": "Hola Magdaleno"}, 200

# Esta es la variable que Lambda buscará (definida en el CMD como main.handler)
handler = Mangum(app)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)