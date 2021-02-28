from flask import Flask, request, jsonify

from capture import captura_rostro

app = Flask(__name__)

@app.route('/register/faces', methods=['POST'])
def camera_ws():
	nombre = request.json['nombre']
	apellido = request.json['apellido']
	captura_rostro(nombre, apellido)
	return jsonify({"status": 200, "message": "Captura de rostro finalizada"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=False, port=4001)
